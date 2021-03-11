locals {
  // S3 media bucket is the CF distribution origin
  media_bucket_key = var.s3_bucket_names[1]
}

resource "aws_cloudfront_distribution" "s3_dist" {
  origin {
    domain_name = aws_s3_bucket.wp[local.media_bucket_key].bucket_regional_domain_name
    origin_id   = aws_s3_bucket.wp[local.media_bucket_key].id
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.wp[local.media_bucket_key].id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}