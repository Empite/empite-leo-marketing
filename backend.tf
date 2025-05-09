terraform {
  required_version = ">= 1.2.6"
  # https://www.terraform.io/downloads.html
  required_providers {
    aws = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest
      source  = "hashicorp/aws"
      version = "~> 4.59.0"
    }
    cloudflare = {
      # https://registry.terraform.io/providers/cloudflare/cloudflare/latest
      source  = "cloudflare/cloudflare"
      version = "~> 3.20.0"
    }
  }
  backend "s3" {
    bucket = "leo-2505-terraform"
    key    = "leo-empite/commingsoon.tfstate"
    region = "ap-southeast-2"
  }
}