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
  default     = "apc-acg-wp"
}

variable "s3_bucket_names" {
  description = "The S3 bucket names to deploy to AWS"
  type        = list(string)
  // Create two buckets for WP code and WP media
  default = ["code", "media"]
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC to deploy to AWS"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_cidr_format_string" {
  description = "The format string to use for subnet CIDR blocks"
  type        = string
  default     = "192.168.%s.0/24"
}

variable "my_public_ip" {
  description = "The public IP address to allow for SSH into the web security group"
  type        = string
  sensitive   = true
  # Set using TF_VAR_my_public_ip
}