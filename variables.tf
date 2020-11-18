variable "username" {
  type        = string
  description = "The desired username for our user"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tag you want to apply to taggable resources"
}

variable "policy" {
  description = "Policy to attach to the user so it can perform its actions"
  type        = string
  default     = null
}

variable "ssm_kms_key_alias" {
  type        = string
  default     = "alias/aws/ssm"
  description = "Alias of the desired KMS Key used to encrypt the SECRET_ACCESS_KEY parameter"
}

variable "ssm_parameter_key_prefix" {
  type        = string
  default     = "/credentials/providers/aws"
  description = "The parent SSM path for our generated access keys"
}

variable "ssm_parameter_template" {
  type        = string
  default     = "$${prefix}/$${username}/$${key}"
  description = "Template used to build the SSM parameter key."
}