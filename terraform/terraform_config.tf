terraform {
  required_version = ">= 0.12.17"
}

provider "aws" {
  region = "eu-west-1"
  profile = "sandbox"
}

