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

variable "vpcs" {
  description = "The networks to deploy to AWS"
  type        = map(string)
  default = {
    "net1" : "10.0.0.0/24"
    "net2" : "10.1.0.0/24"
    "net3" : "10.2.0.0/24"
  }
}

variable "subnets" {
  description = "The subnets to deploy to each AWS VPC"
  type        = map(list(string))
  default = {
    "net1" : ["10.0.0.0/28", "10.0.0.16/28"],
    "net2" : ["10.0.0.0/28", "10.0.0.16/28"],
    "net3" : ["10.0.0.0/28", "10.0.0.16/28"],
  }
}
