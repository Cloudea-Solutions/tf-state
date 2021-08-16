module "terraform_state_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.33.0"

  profile = var.profile

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
        "Resource" : "${module.terraform_state_backend.dynamodb_table_name}"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "${module.terraform_state_backend.s3_bucket_arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject"],
        "Resource" : "${module.terraform_state_backend.s3_bucket_arn}/var.terraform_state_file"
      }
    ]
  })

  tags = module.this.tags
}