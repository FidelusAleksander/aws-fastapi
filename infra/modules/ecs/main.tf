resource "aws_ecs_cluster" "aws_fastapi_cluster" {
  name = "aws_fastapi_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
