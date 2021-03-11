resource "aws_s3_bucket" "wp_code" {
  bucket = join(var.dl, [var.name_prefix, "wordpress", "code"])
}

resource "aws_s3_bucket" "wp_media" {
  bucket = join(var.dl, [var.name_prefix, "wordpress", "media"])
}