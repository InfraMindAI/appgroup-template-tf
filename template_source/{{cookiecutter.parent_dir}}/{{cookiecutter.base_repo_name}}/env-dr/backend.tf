terraform {
  backend "s3" {
    bucket       = "terraform-dr"
    key          = "{{cookiecutter.base_repo_name}}/prod.tfstate"
    region       = "ca-central-1"
    role_arn     = "arn:aws:iam::1234567890:role/tf"
    session_name = "{{cookiecutter.base_session_name}}"
  }
}