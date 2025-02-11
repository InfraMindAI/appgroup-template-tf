terraform {
  backend "s3" {
    bucket       = "terraform"
    key          = "{{cookiecutter.base_repo_name}}/alpha.tfstate"
    region       = "us-east-1"
    role_arn     = "arn:aws:iam::1234567890:role/tf"
    session_name = "{{cookiecutter.base_session_name}}"
  }
}