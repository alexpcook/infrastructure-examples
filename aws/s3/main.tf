provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  for_each = var.s3_buckets

  bucket_prefix = format("%s-%s-", var.bucket_prefix, each.value.name_prefix)

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "object" {
  for_each = {
    for pair in setproduct(keys(var.s3_buckets), fileset(format("%s/", var.source_directory), "*")) : format("%s-%s", pair[0], pair[1]) => {
      bucket_key    = pair[0]
      object_key    = pair[1]
      object_source = join("/", [var.source_directory, pair[1]])
    }
  }

  bucket       = aws_s3_bucket.bucket[each.value.bucket_key].id
  key          = each.value.object_key
  source       = each.value.object_source
  etag         = filemd5(each.value.object_source)
  content_type = lookup(var.mime_types, regex("\\.[a-z0-9]+$", each.value.object_key), null)
  acl          = var.s3_buckets[each.value.bucket_key].object_acl
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  for_each = var.s3_buckets

  bucket                  = aws_s3_bucket.bucket[each.key].id
  block_public_acls       = each.value.block_public_access
  block_public_policy     = each.value.block_public_access
  ignore_public_acls      = each.value.block_public_access
  restrict_public_buckets = each.value.block_public_access
}
