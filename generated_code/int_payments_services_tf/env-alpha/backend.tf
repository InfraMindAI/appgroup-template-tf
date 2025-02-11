terraform {
  backend "s3" {
    bucket       = "terraform"
    key          = "int_payments_services_tf/alpha.tfstate"
    region       = "us-east-1"
    role_arn     = "arn:aws:iam::1234567890:role/tf"
    session_name = "INT_PAYMENTS_SERVICES_TF"
  }
}