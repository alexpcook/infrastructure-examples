variable "profile" {
  description = "The AWS profile to deploy to"
  type        = string
  # This can be set with an environment variable called TF_VAR_profile
}

variable "regions" {
  description = "The AWS regions to deploy to (must have a corresponding workspace)"
  type        = map(string)
  default = {
    "us-west-1" : "sfo",
    "eu-west-2" : "lhr",
  }
}

variable "envs" {
  description = "The environments to deploy to AWS"
  type        = set(string)
  default     = ["dev", "uat", "prd"]
}

variable "vpcs" {
  description = "The VPCs to deploy to AWS"
  type        = map(string)
  default = {
    "net1" : "10.0.0.0/24",
    "net2" : "192.168.0.0/24",
  }
}
