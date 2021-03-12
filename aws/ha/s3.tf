resource "aws_s3_bucket" "wp" {
  for_each = toset(var.s3_bucket_names)

  bucket = join(var.dl, [var.name_prefix, each.value])
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  for_each = aws_s3_bucket.wp

  bucket = each.value.id

  // allow public access only to media bucket
  block_public_acls       = each.key == local.media_bucket_key ? false : true
  block_public_policy     = each.key == local.media_bucket_key ? false : true
  ignore_public_acls      = each.key == local.media_bucket_key ? false : true
  restrict_public_buckets = each.key == local.media_bucket_key ? false : true
}

resource "aws_s3_bucket_policy" "allow_public_reads" {
  bucket = aws_s3_bucket.wp[local.media_bucket_key].id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.wp[local.media_bucket_key].arn}/*"
        ]
      }
    ]
  })
}