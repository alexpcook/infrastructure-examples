resource "aws_s3_bucket" "wp" {
  for_each = toset(var.s3_bucket_names)

  bucket = join(var.dl, [var.name_prefix, "wordpress", each.value])
}

resource "aws_s3_bucket_public_access_block" "block_all" {
  for_each = aws_s3_bucket.wp

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}