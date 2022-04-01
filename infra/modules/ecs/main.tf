resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.ecs_execution_role_arn
  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-container"
      image = local.ecr_image
  }])
}

locals {
  ecr_image = "${var.ecr_repository_url}:${var.image_tag}"
}
