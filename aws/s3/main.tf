provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "public" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket" "private" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset(var.source_directory, "*")
  bucket   = aws_s3_bucket.public.id
  key      = each.value
  source   = join("", [var.source_directory, each.value])
  etag     = filemd5(join("", [var.source_directory, each.value]))
}
