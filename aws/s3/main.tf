provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "b1" {
  bucket_prefix = "acg"
}

resource "aws_s3_bucket" "b2" {
  bucket_prefix = "acg"
}
