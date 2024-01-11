variable "domain_name" {
  description = "The main domain of this config"
  default     = "christiantoledana.com"
}

variable "default_email" {
  description = "The main email of this config"
  default     = "admin@christiantoledana.com"
}

variable "default_tags" {
  description = "The default tags of resources"
  default = {
    ManagedBy = "Terraform"
  }
}