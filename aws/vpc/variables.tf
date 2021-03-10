variable "profile" {
  description = "The AWS profile to deploy to"
  type        = string
  # This can be set with an environment variable using TF_VAR_* syntax
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-1" # N. California
}

variable "network" {
  description = "The network to deploy to AWS"
  type        = map(list(string))
  default = {
    "10.0.0.0/24" = ["10.0.0.0/28", "10.0.0.16/28"],
  }
}
