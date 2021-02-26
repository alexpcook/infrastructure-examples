variable "region" {
  type    = string
  default = "us-west-1"
}

variable "users" {
  type    = list(string)
  default = ["alex.cook"]
}

variable "groups" {
  type    = list(string)
  default = ["administrators"]
}
