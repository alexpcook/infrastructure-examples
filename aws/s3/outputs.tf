output "s3-public-url" {
  value = format("https://%s/", aws_s3_bucket.public.bucket_domain_name)
}

output "s3-private-url" {
  value = format("https://%s/", aws_s3_bucket.private.bucket_domain_name)
}
