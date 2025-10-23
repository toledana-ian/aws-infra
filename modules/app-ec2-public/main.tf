
# Security Group for the app allowing HTTP/HTTPS and SSH
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name} EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = var.tags
}

# Find latest Ubuntu 22.04 LTS (Jammy) AMI
# Canonical owner ID: 099720109477
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role for SSM access
resource "aws_iam_role" "ssm" {
  name = "${var.name}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ssm.name
  tags = var.tags
}

# EC2 Instance
resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.this.name

  user_data = <<-EOF
              #!/bin/bash
              set -xe
              export DEBIAN_FRONTEND=noninteractive
              apt-get update -y || true
              apt-get upgrade -y || true

              # Ensure snap is available and install SSM Agent on Ubuntu
              if ! command -v snap >/dev/null 2>&1; then
                apt-get install -y snapd || true
                systemctl enable --now snapd || true
              fi

              snap install amazon-ssm-agent --classic || true
              systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service || true
              EOF

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Elastic IP
resource "aws_eip" "this" {
  domain = "vpc"
  tags   = var.tags
}

resource "aws_eip_association" "this" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

# DNS record
resource "aws_route53_record" "this" {
  zone_id = var.route_zone_id
  name    = "${var.route_app_sub_domain_name}.${var.route_domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}
