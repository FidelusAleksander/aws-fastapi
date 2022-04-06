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

module "iam_ecs" {
  source              = "./modules/iam/ecs"
  project_name        = var.project_name
  ecr_repository_name = var.ecr_repository_name
}
#module "instance" {
#  source = "./modules/instance"
#}

module "ecs" {
  source                 = "./modules/ecs"
  project_name           = var.project_name
  ecr_repository_name    = var.ecr_repository_name
  vpc_id                 = var.vpc_id
  ecs_execution_role_arn = module.iam_ecs.ecr_execution_role_arn
}

module "dynamo" {
  source       = "./modules/dynamo"
  project_name = var.project_name
}
