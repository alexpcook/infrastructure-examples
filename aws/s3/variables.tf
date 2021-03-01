variable "region" {
  type    = string
  default = "us-west-1"
}

variable "bucket_prefix" {
  type    = string
  default = "acg-"
}

variable "source_directory" {
  type    = string
  default = "src/"
}
