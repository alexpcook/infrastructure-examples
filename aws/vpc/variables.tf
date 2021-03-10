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

variable "vpcs" {
  description = "The networks to deploy to AWS"
  type        = map(string)
  default = {
    "dev" : "10.0.1.0/24",
    "uat" : "10.0.2.0/24",
    "prd" : "10.0.3.0/24",
  }
}

variable "subnets" {
  description = "The subnets to deploy to each AWS VPC"
  type        = map(list(string))
  default = {
    "dev" : ["10.0.1.0/28", "10.0.1.16/28"],
    "uat" : ["10.0.2.0/28", "10.0.2.16/28"],
    "prd" : ["10.0.3.0/28", "10.0.3.16/28"],
  }
}
