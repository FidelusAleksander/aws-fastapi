resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project_name}-ecr"
  image_tag_mutability = "MUTABLE"
}

output "repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "ecr_arn" {
  value = aws_ecr_repository.ecr.arn
}
