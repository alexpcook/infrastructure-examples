variable "profile" {
  description = "The AWS profile to deploy to"
  type        = string
  # This can be set with an environment variable called TF_VAR_profile
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-1" # N. California
}

variable "envs" {
  description = "The environments to deploy to AWS"
  type        = set(string)
  default     = ["dev", "uat", "prd"]
}
