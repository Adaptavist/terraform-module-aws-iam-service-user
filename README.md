# AWS IAM Service User

This module creates an IAM user for you whilst persisting its access keys in SSM as parameters for your team to look up.

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
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policy | Policy to attach to the user so it can perform its actions | `string` | `null` | no |
| ssm\_kms\_key\_alias | Alias of the desired KMS Key used to encrypt the SECRET\_ACCESS\_KEY parameter | `string` | `"alias/aws/ssm"` | no |
| ssm\_parameter\_key\_prefix | The parent SSM path for our generated access keys | `string` | `"/credentials/providers/aws"` | no |
| ssm\_parameter\_template | Template used to build the SSM parameter key. | `string` | `"${prefix}/${username}/${key}"` | no |
| tags | Tag you want to apply to taggable resources | `map(string)` | `{}` | no |
| username | The desired username for our user | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ssm\_access\_key\_param\_path | SSM parameter path to the AWS access key ID |
| ssm\_parameter\_prefix | SSM parameter path prefixing the variables |
| ssm\_secret\_key\_param\_path | SSM parameter path to the AWS secret key |

