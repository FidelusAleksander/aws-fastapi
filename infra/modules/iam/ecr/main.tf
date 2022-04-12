data "aws_ecr_repository" "ecr" {
  name = var.ecr_repository_name
}

resource "aws_iam_role_policy" "authorize_cluster_to_ecr" {
  role   = var.role_id
  policy = data.aws_iam_policy_document.authorize_cluster_to_ecr.json
}

resource "aws_iam_role_policy" "ecr_image_access_policy" {
  role   = var.role_id
  policy = data.aws_iam_policy_document.ecr_image_access_policy.json
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