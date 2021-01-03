provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-09d9c5cdcfb8fc655" // RHEL
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.internet.id

  tags = {
    "os" = "rhel"
  }
}

resource "aws_vpc" "web_tier" {
  cidr_block = "172.16.0.0/24"

  tags = {
    "tier" = "web"
  }
}

resource "aws_subnet" "internet" {
  vpc_id     = aws_vpc.web_tier.id
  cidr_block = "172.16.0.0/28"

  tags = {
    "tier" = "web"
  }
}