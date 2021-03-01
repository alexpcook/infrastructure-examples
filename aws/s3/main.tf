provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "public" {
  bucket_prefix = join("-", [var.bucket_prefix, "public"])
}

resource "aws_s3_bucket" "private" {
  bucket_prefix = join("-", [var.bucket_prefix, "private"])
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset(format("%s/", var.source_directory), "*")
  bucket   = aws_s3_bucket.public.id
  key      = each.value
  source   = join("/", [var.source_directory, each.value])
  etag     = filemd5(join("/", [var.source_directory, each.value]))
}
