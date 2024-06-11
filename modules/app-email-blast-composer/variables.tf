variable "name" {
  type = string
  description = "The name that will be assigned to the resources created by this module"
}

variable "random_suffix" {
  description = "A random string suffix to ensure S3 bucket name and secret's manager uniqueness. Only lowercase alphanumeric characters and hyphens."
  type        = string
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

variable "enable_digest_authentication" {
  type    = bool
  description = "Determines if Digest Authentication should be enabled for viewer requests in the CloudFront distribution."
}
