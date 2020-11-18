// SSM parameter path prefixing the variables
output "ssm_parameter_prefix" {
  value = data.template_file.param_prefix.rendered
}

// SSM parameter path to the AWS access key ID
output "ssm_access_key_param_path" {
  value = aws_ssm_parameter.access_key_id.name
}

// SSM parameter path to the AWS secret key
output "ssm_secret_key_param_path" {
  value = aws_ssm_parameter.secret_key.name
}