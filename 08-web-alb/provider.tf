terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "balasai16"
    key    = "expense-dev-web-alb"
    region = "us-east-1"
    dynamodb_table = "daws79s-locking"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}