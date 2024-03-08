terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  # configured backend to store the terraform.tfstate file in s3 bucket called terraform-bucket-for-state-s3
  backend "s3" {
    bucket  = "terraform-bucket-for-state-s3"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "terraform_locks"

    # Specify the profile if you're using AWS credentials profile
    profile = "my_aws_profile"
  }

  required_version = ">= 1.2.0"
}

// lets me pull data about the available AZ's
data "aws_availability_zones" "available" {}


// I need to figure out how to work in 2 regions

provider "aws" {
  region = "us-east-1"

  shared_credentials_files = ["/mnt/c/Users/esopa/.aws/credentials"]
  shared_config_files      = ["/mnt/c/Users/esopa/.aws/config"]

  // the profile is found in the ~/.aws/credentials file and im setting the region here
  # profile = "my_aws_profile_e"
  profile = "my_aws_profile"
}