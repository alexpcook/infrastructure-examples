resource "aws_s3_bucket" "wp" {
  for_each = toset(var.s3_bucket_names)

  bucket = join(var.dl, [var.name_prefix, each.value])
}

resource "aws_s3_bucket_public_access_block" "block_all" {
  for_each = aws_s3_bucket.wp

  bucket = each.value.id

  // allow public access only to media bucket
  block_public_acls       = each.key == var.s3_bucket_names[1] ? false : true
  block_public_policy     = each.key == var.s3_bucket_names[1] ? false : true
  ignore_public_acls      = each.key == var.s3_bucket_names[1] ? false : true
  restrict_public_buckets = each.key == var.s3_bucket_names[1] ? false : true
}