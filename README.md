# Terraform State Module

Terraform module for backend state management using AWS S3 bucket and DynamoDB locking table. 

This module makes use of [Cloud Posse Terraform modules](https://github.com/orgs/cloudposse/repositories?q=terraform).

This module also creates a policy that can be attached to a role to give access to the S3 bucket and DynamoDB table. This could be used, for example, to create a CodeBuild script that assumes a role with this policy attached and then deploys infrastructure into another account via Terraform CLI.

## Usage

Make sure you include `context.tf` from [Cloud Posse Null Label](https://github.com/cloudposse/terraform-null-label) in your own project.

main.tf
```hcl
module "terraform_state_backend" {
  source = "github.com/Rail-Cloud-Formation/tf-state"

  context = module.this.context
}
```

Define some variables for your own use case. With the below parameters the resulting bucket name will be `rcf-dev-state` and DynamoDB table will be `rcf-dev-state-lock`.

dev.ap-southeast-2.tfvars
```hcl
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