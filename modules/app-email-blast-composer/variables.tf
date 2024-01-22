variable "name" {
  type = string
  description = "The name that will be assigned to the resources created by this module"
}

variable "route_domain_name" {
  type = string
  description = "The domain name for the route"
}

variable "route_app_sub_domain_name" {
  type = string
  description = "The subdomain name for the app route"
}

variable "route_zone_id" {
  type = string
  description = "The ID of the zone in which the route is defined"
}

variable "acm_certificate_arn" {
  type = string
  description = "The ARN of the ACM certificate"
}

variable "tags" {
  description = "A map of tags that will be added to the resources created by this module"
}