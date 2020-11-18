module "minimal" {
  source   = "../"
  username = "service-user-test-minimal"
}

data "testing_assertions" "minimal" {
  equal "ssm_parameter_prefix" {
    got  = module.minimal.ssm_parameter_prefix
    want = "/credentials/providers/aws/service-user-test-minimal/"
  }

  equal "ssm_access_key_param_path" {
    got  = module.minimal.ssm_access_key_param_path
    want = "/credentials/providers/aws/service-user-test-minimal/ACCESS_KEY_ID"
  }

  equal "ssm_secret_key_param_path" {
    got  = module.minimal.ssm_secret_key_param_path
    want = "/credentials/providers/aws/service-user-test-minimal/SECRET_ACCESS_KEY"
  }
}