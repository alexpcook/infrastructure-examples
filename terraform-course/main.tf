provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-09d9c5cdcfb8fc655" // RHEL
  instance_type = "t2.micro"

  tags = {
    "os" = "rhel"
  }
}