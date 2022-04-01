resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project_name}-ecr"
  image_tag_mutability = "MUTABLE"
}

output "ecr_name" {
  value = aws_ecr_repository.ecr.name
}
