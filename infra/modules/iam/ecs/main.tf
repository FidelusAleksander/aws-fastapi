data "aws_iam_policy_document" "ecs_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Execution role
resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}


# Task role
resource "aws_iam_role" "ecs_tasks_container_role" {
  name               = "${var.project_name}-ecs-task-container-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}
