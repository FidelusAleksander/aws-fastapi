data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions = [
      "*"
    ]

    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_role_policy" "s3_access_policy" {
  role   = var.role_id
  policy = data.aws_iam_policy_document.s3_access_policy.json
}
