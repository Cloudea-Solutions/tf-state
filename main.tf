module "terraform_state_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.33.0"

  namespace  = module.this.namespace
  stage      = module.this.stage
  name       = module.this.name
  profile    = var.profile
  attributes = []

  billing_mode = "PAY_PER_REQUEST"

  terraform_backend_config_file_path = var.terraform_backend_config_file_path
  terraform_backend_config_file_name = var.terraform_backend_config_file_name
  terraform_state_file               = var.terraform_state_file

  force_destroy = false
}