terraform {
  backend "s3" {
    bucket       = "terraform"
    key          = "{{cookiecutter.services_repo_name}}/prod.tfstate"
    region       = "us-east-1"
    role_arn     = "arn:aws:iam::1234567890:role/tf"
    session_name = "{{cookiecutter.services_session_name}}"
  }
}