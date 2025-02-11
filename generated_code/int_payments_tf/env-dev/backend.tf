terraform {
  backend "s3" {
    bucket       = "terraform"
    key          = "int_payments_tf/dev.tfstate"
    region       = "us-east-1"
    role_arn     = "arn:aws:iam::1234567890:role/tf"
    session_name = "INT_PAYMENTS_TF"
  }
}