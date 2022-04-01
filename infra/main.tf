terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
  required_version = ">= 1.1.0"

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

#module "instance" {
#  source = "./modules/instance"
#}

module "ecs" {
  source = "./modules/ecs"
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}
