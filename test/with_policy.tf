data "aws_iam_policy_document" "with_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
  }
}

module "with_policy" {
  source   = "../"
  username = "service-user-test-with-policy"
  policy   = data.aws_iam_policy_document.with_policy.json
}