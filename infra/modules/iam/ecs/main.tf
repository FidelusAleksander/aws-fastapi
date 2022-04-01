data "aws_iam_policy_document" "ecs_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_image_access_policy" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [var.ecr_arn]
  }
}

data "aws_iam_policy_document" "authorize_cluster_to_ecr" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_role_policy" "authorize_cluster_to_ecr" {
  role   = aws_iam_role.ecs_tasks_execution_role.id
  policy = data.aws_iam_policy_document.authorize_cluster_to_ecr.json
}

resource "aws_iam_role_policy" "ecr_image_access_policy" {
  role   = aws_iam_role.ecs_tasks_execution_role.id
  policy = data.aws_iam_policy_document.ecr_image_access_policy.json
}
