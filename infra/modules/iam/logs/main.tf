data "aws_iam_policy_document" "cloudwatch_logs_access" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*"
    ]
  }
}
resource "aws_iam_role_policy" "cloudwatch_logs_access" {
  role   = var.role_id
  policy = data.aws_iam_policy_document.cloudwatch_logs_access.json
}
