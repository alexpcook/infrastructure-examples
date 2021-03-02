variable "region" {
  type    = string
  default = "us-west-1"
}

variable "profile" {
  type = string
}

variable "users" {
  type    = list(string)
  default = ["alex.cook"]
}

variable "groups" {
  type    = list(string)
  default = ["administrators"]
}

variable "path" {
  type    = string
  default = "/acg/"
}

variable "ec2_sts_assume_role_policy_json" {
  type    = string
  default = "ec2_sts_assume_role_policy.json"
}

variable "pgp_key" {
  type    = string
  default = "keybase:alexpcook"
}
