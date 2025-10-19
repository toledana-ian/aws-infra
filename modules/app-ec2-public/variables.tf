variable "name" {
  description = "Name for the EC2 app resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where the instance will be launched"
  type        = string
}

variable "route_zone_id" {
  description = "Route53 hosted zone ID for DNS record"
  type        = string
}

variable "route_domain_name" {
  description = "Route53 hosted zone domain name (e.g., example.com)"
  type        = string
}

variable "route_app_sub_domain_name" {
  description = "Subdomain for the app (e.g., chess-api)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(any)
  default     = {}
}
