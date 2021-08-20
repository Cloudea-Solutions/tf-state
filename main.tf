module "terraform_state_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.33.0"

  billing_mode = "PAY_PER_REQUEST"

  terraform_backend_config_file_path = var.terraform_backend_config_file_path
  terraform_backend_config_file_name = var.terraform_backend_config_file_name
  terraform_state_file               = var.terraform_state_file

  force_destroy = false

  context = module.this.context
}

resource "aws_iam_policy" "terraform_access_policy" {
  name        = "${module.this.id}-terraform-access-policy"
  path        = "/"
  description = "Gives Terraform access to manage remote state via S3 bucket and DynamoDB locking table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        "Resource" : "${module.terraform_state_backend.dynamodb_table_arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "${module.terraform_state_backend.s3_bucket_arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject"],
        "Resource" : "${module.terraform_state_backend.s3_bucket_arn}/${var.terraform_state_file}"
      }
    ]
  })

  tags = module.this.tags
}

resource "aws_ssm_parameter" "terraform_policy_name" {
  name        = "/${module.this.namespace}/${module.this.name}/terraform-policy-name"
  type        = "String"
  value       = aws_iam_policy.terraform_access_policy.id
  description = "The name of the Terraform access policy"
}

resource "aws_ssm_parameter" "backend_state_bucket" {
  name        = "/${module.this.namespace}/${module.this.name}/bucket"
  type        = "String"
  value       = module.terraform_state_backend.s3_bucket_id
  description = "The name of the backend state S3 bucket"
}

resource "aws_ssm_parameter" "backend_state_dynamodb_table" {
  name        = "/${module.this.namespace}/${module.this.name}/dynamodb-table"
  type        = "String"
  value       = module.terraform_state_backend.dynamodb_table_name
  description = "The name of the backend state DynamoDB locking table"
}