/**
 * # AWS IAM Service User
 *
 * This module creates an IAM user for you whilst persisting its access keys in SSM as parameters for your team to look up.
 *
 * ## Examples
 *
 * ```terraform
 * // You must provide an IAM policy for this user, it won't be able to do much otherwise.
 * data "aws_iam_policy_document" "deploy_user_policy" {
 *   statement {
 *     sid       = "AssumeRoles"
 *     effect    = "Allow"
 *     actions   = ["sts:AssumeRole"]
 *     resources = ["*"]
 *   }
 * }
 * 
 * module "deploy_user" {
 *   source   = "git::https://github.com/Adaptavist/terraform-module-aws-iam-service-user.git" // make sure to pin to a branch!
 *   username = "my-deployment-user"
 *   policy   = data.aws_iam_policy_document.deploy_user_policy.json
 *   tags     = { 
 *     MyTagName: "MyTagValue"
 *   }
 * }
 * ```
 */

terraform {
  required_providers {
    aws = {
      version = ">= 2.64.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_iam_user" "this" {
  name = var.username
  tags = var.tags
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "this" {
  count  = var.policy != null ? 1 : 0
  user   = aws_iam_user.this.name
  policy = var.policy
}

data "aws_kms_alias" "this" {
  name = var.ssm_kms_key_alias
}

data "template_file" "param_prefix" {
  template = var.ssm_parameter_template
  vars = {
    prefix   = var.ssm_parameter_key_prefix
    username = var.username
    key      = ""
  }
}

data "template_file" "access_key_param_key" {
  template = var.ssm_parameter_template
  vars = {
    prefix   = var.ssm_parameter_key_prefix
    username = var.username
    key      = "ACCESS_KEY_ID"
  }
}

resource "aws_ssm_parameter" "access_key_id" {
  name  = data.template_file.access_key_param_key.rendered
  type  = "String"
  value = aws_iam_access_key.this.id
  tags  = var.tags
}

data "template_file" "secret_key_param_key" {
  template = var.ssm_parameter_template
  vars = {
    prefix   = var.ssm_parameter_key_prefix
    username = var.username
    key      = "SECRET_ACCESS_KEY"
  }
}

resource "aws_ssm_parameter" "secret_key" {
  name   = data.template_file.secret_key_param_key.rendered
  type   = "SecureString"
  key_id = data.aws_kms_alias.this.target_key_id
  value  = aws_iam_access_key.this.secret
  tags   = var.tags
}