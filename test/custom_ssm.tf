module "custom_ssm" {
  source                   = "../"
  username                 = "service-user-test-custom-ssm"
  ssm_parameter_key_prefix = "my-prefix"
  ssm_parameter_template   = "$${prefix}-$${username}-$${key}"
}

data "testing_assertions" "custom_ssm" {
  equal "ssm_parameter_prefix" {
    got  = module.custom_ssm.ssm_parameter_prefix
    want = "my-prefix-service-user-test-custom-ssm-"
  }

  equal "ssm_access_key_param_path" {
    got  = module.custom_ssm.ssm_access_key_param_path
    want = "my-prefix-service-user-test-custom-ssm-ACCESS_KEY_ID"
  }

  equal "ssm_secret_key_param_path" {
    got  = module.custom_ssm.ssm_secret_key_param_path
    want = "my-prefix-service-user-test-custom-ssm-SECRET_ACCESS_KEY"
  }
}