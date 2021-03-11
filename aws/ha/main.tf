terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = terraform.workspace == "default" ? "us-west-1" : terraform.workspace
}