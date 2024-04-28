# Terraform Block
terraform {
  required_version = "~> 1.6.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Provider Block 
provider "aws" {
  region  = "us-east-2"
  profile = "default"
}