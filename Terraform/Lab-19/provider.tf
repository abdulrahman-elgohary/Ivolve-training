terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket = "state-file-bucket-11-10-2024"
    key    = "terraform-file-state.tfstate"
    region = "us-east-1"
    dynamodb_table = "Lock_users"
  }
}


provider "aws" {
  region = "us-east-1"
 
}
