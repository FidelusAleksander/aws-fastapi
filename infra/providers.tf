terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
  required_version = ">= 1.3.2"

  cloud {
    organization = "aws-fastapi"

    workspaces {
      name = "aws-fastapi"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}
