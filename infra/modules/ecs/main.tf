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

data "aws_vpc" "main" {
  id = "vpc-54c9792d"
}
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.main.id
}

resource "aws_ecs_service" "service" {
  name            = "${var.project_name}-ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnet_ids.subnet_ids.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_task_sg.id]
  }
}


resource "aws_security_group" "ecs_task_sg" {
  name   = "${var.project_name}-ecs-task-sg"
  vpc_id = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = [443, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
