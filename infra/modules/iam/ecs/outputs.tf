output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}

output "ecs_execution_role_id" {
  value = aws_iam_role.ecs_tasks_execution_role.id
}

output "ecs_tasks_container_role" {
  value = aws_iam_role.ecs_tasks_container_role.arn
}

output "ecs_tasks_container_role_id" {
  value = aws_iam_role.ecs_tasks_container_role.id
}
