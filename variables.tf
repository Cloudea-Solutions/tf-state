variable "terraform_backend_config_file_path" {
  type        = string
  description = "Directory for the terraform backend config file, usually `.`. The default is to create no file."
  default     = "."
}

variable "terraform_backend_config_file_name" {
  type        = string
  description = "Name of terraform backend config file"
  default     = "backend.tf"
}

variable "terraform_state_file" {
  type        = string
  description = "The path to the state file inside the bucket"
  default     = "terraform.tfstate"
}