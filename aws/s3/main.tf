provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "public" {
  bucket_prefix = join("-", [var.bucket_prefix, "public"])
}

resource "aws_s3_bucket" "private" {
  bucket_prefix = join("-", [var.bucket_prefix, "private"])
}

resource "aws_s3_bucket_object" "public" {
  for_each = fileset(format("%s/", var.source_directory), "*")
  bucket   = aws_s3_bucket.public.id
  key      = each.value
  source   = join("/", [var.source_directory, each.value])
  etag     = filemd5(join("/", [var.source_directory, each.value]))
}

resource "aws_s3_bucket_object" "private" {
  for_each = fileset(format("%s/", var.source_directory), "*")
  bucket   = aws_s3_bucket.private.id
  key      = each.value
  source   = join("/", [var.source_directory, each.value])
  etag     = filemd5(join("/", [var.source_directory, each.value]))
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket                  = aws_s3_bucket.public.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
