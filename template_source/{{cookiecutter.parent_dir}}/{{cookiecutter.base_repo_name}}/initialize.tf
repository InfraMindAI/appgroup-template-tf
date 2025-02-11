terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }

  required_version = "1.3.3"
}

provider "aws" {
  region  = var.base_config["region"]

  assume_role {
    role_arn     = var.provider_config["role_arn"]
    session_name = var.provider_config["session_name"]
  }
}