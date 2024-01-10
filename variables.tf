variable "domain_name" {
  description = "The main domain of this config"
  default     = "christiantoledana.com"
}

variable "default_email" {
  description = "The main email of this config"
  default     = "admin@christiantoledana.com"
}

variable "sud_domain_dynamdev_email_blast"{
  description = "The sub domain for dynamdev email blast app"
  default     = "dynamdev-email-blast"
}