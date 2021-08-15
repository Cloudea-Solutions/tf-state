# Terraform State Module

Terraform module for backend state management using AWS S3 bucket and DynamoDB locking table. 

This module makes use of [Cloud Posse Terraform modules](https://github.com/orgs/cloudposse/repositories?q=terraform).

## Usage

Make sure you include `context.tf` from [Cloud Posse Null Label](https://github.com/cloudposse/terraform-null-label) in your own project.

main.tf
```hcl
module "terraform_state_backend" {
  source = "github.com/Rail-Cloud-Formation/tf-state"

  profile    = var.profile
  region     = var.region

  context = module.this.context
}
```

Define some variables for your own use case. The following specifies the Sydney AWS region and a credentials profile called `developer`. With the below parameters the resulting bucket name will be `rcf-dev-state` and DynamoDB table will be `rcf-dev-state-lock`.

dev.ap-southeast-2.tfvars
```hcl
region = "ap-southeast-2"
profile = "developer"

namespace = "rcf"
name = "state"
environment = "apse2"
stage = "dev"
```

Initialise and apply the backend.

```
terraform init
terraform apply -var-file dev.ap-southeast-2.tfvars
```