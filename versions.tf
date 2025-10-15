terraform {
  required_version = ">= 1.8.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
  backend "s3" {
    bucket         = "medyk-tf-state"
    key            = "state/ecs-cluster.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "medyk-tf-lock"
    encrypt        = true
  }
}


provider "aws" {
  region = var.region
  # shared_credentials_files = [""]
  # allowed_account_ids      = [""]
  default_tags {
    tags = {
      Owner = var.username
      Repo  = var.repo
    }
  }
}
