data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_ecr_repository" "ecr" {
  name = var.ecr_repository_name
}
