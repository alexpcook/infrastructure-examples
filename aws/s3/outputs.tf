output "s3-url" {
  value = {
    for bucket in aws_s3_bucket.bucket : bucket.id => "https://${bucket.bucket_domain_name}/"
  }
}
