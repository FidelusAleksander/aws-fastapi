data "aws_ecr_repository" "ecr" {
  name = var.ecr_repository_name
}

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

    resources = [data.aws_ecr_repository.ecr.arn]
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

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_role" "ecs_tasks_container_role" {
  name               = "${var.project_name}-ecs-task-container-role"
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

resource "aws_iam_role_policy" "s3_access_policy" {
  role   = aws_iam_role.ecs_tasks_container_role.id
  policy = data.aws_iam_policy_document.s3_access_policy.json
}
