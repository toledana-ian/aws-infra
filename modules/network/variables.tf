variable "tags" {
  description = "A map of tags that will be added to the resources created by this module"
}

variable "environment"{
  type = string
  description = "Environment of the network, this will define the prefix of the resource names that will be created by this module"

  validation {
    condition     = contains(["production", "staging", "testing", "development"], var.environment)
    error_message = "The environment must be production, staging, testing, or development."
  }
}

variable "create_igw" {
  description = "Determines whether to create an Internet Gateway"
  type        = bool
  default     = true
}