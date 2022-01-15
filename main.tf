terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

# Default provider
provider "aws" {
  region = "us-east-1"

  profile = "terraform"
}

# In order to deploy to multi-region
provider "aws" {
  region = "us-east-2"
  alias  = "ohio"

  profile = "terraform"
}