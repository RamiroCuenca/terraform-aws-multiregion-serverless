terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"

  profile = "terraform"
}