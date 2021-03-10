variable "profile" {
  description = "The AWS profile to deploy to"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-1" # N. California
}
