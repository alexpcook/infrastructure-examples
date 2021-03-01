variable "region" {
  description = "The AWS region name"
  type        = string
  default     = "us-west-1"
}

variable "bucket_prefix" {
  description = "The prefix for the S3 bucket names"
  type        = string
  default     = "acg"
}

variable "source_directory" {
  description = "The application source code sub-directory"
  type        = string
  default     = "src"
}

variable "mime_types" {
  description = "The content-type headers for each file type in source"
  type        = map(string)
  default = {
    ".html" : "text/html",
    ".txt" : "text/plain",
  }
}

variable "s3_buckets" {
  description = "Specifications for creating S3 buckets"
  type = map(object({
    name_prefix         = string
    block_public_access = bool
    object_acl          = string

  }))
  default = {
    "b1" = {
      name_prefix         = "public"
      block_public_access = false
      object_acl          = "public-read"
    }
    "b2" = {
      name_prefix         = "private"
      block_public_access = true
      object_acl          = "private"
    }
  }
}
