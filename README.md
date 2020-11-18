# AWS IAM Service User

This module creates an IAM user for you whilst persisting its access keys in \* Secrets Manager as parameters.

## Examples

```terraform
// You must provide an IAM policy for this user, it won't be able to do much otherwise.
data "aws_iam_policy_document" "deploy_user_policy" {
  statement {
    sid       = "AssumeRoles"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

module "deploy_user" {
  source   = "git::https://github.com/Adaptavist/terraform-module-aws-iam-service-user.git" // make sure to pin to a branch!
  username = "my-deployment-user"
  policy   = data.aws_iam_policy_document.deploy_user_policy.json
  tags     = {
    MyTagName: "MyTagValue"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| aws | >= 2.64.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.64.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policy | policy to attach to the user so it can perform its actions | `string` | n/a | yes |
| tags | n/a | `map(string)` | `{}` | no |
| username | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ssm\_parameter\_path | n/a |

