# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

## Terraform configuration

# terraform {
#   cloud {
#     organization = "AmerAlrimawi"
#     workspaces {
#       name = "learn-terraform-cloud-migrate"
#     }
#   }
#   required_providers {
#     random = {
#       source  = "hashicorp/random"
#       version = "3.3.2"
#     }
#   }
#   required_version = ">= 1.1.0"
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
