/**
 * # AWS IAM Service User
 *
 * This module creates an IAM user for you whilst persisting its access keys in * Secrets Manager as parameters.
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
      source = "hashicorp/aws"
    }
  }
}

resource "aws_iam_user" "this" {
  name = var.username
  tags = var.tags
}

resource "aws_iam_user_policy" "this" {
  user   = aws_iam_user.this.name
  policy = var.policy
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_ssm_parameter" "access_key_id" {
  name  = "/service-accounts/${var.username}/ACCESS_KEY_ID"
  type  = "String"
  value = aws_iam_access_key.this.id
}

resource "aws_ssm_parameter" "secret_key" {
  name  = "/service-accounts/${var.username}/SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = aws_iam_access_key.this.secret
}