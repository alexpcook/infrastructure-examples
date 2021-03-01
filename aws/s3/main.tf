provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "b1" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket" "b2" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket_object" "o1" {
  bucket = aws_s3_bucket.b1.id
  key    = "version"
  source = "src/version.txt"
}

resource "aws_s3_bucket_object" "o2" {
  bucket = aws_s3_bucket.b2.id
  key    = "animals"
  source = "src/animals.html"
}
