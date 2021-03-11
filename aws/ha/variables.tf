variable "profile" {
  description = "The AWS profile to deploy to"
  type        = string
  # Set using TF_VAR_profile
}

variable "dl" {
  description = "The delimiter to use in AWS resource names/tags"
  type        = string
  default     = "-"
}

variable "name_prefix" {
  description = "The name prefix to append to AWS resources"
  type        = string
  default     = "apc-acg"
}