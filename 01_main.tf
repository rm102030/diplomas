terraform {
  required_version = "1.4.6"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  # default_tags {
  #     tags = {
  #       Project   = "Lambda Presigned with Terraform"
  #       CreatedAt = formatdate("YYYY-MM-DD", timestamp())
  #       ManagedBy = "Terraform"
  #       Owner     = "RM"
  #     }
  #   }
}

terraform {
  backend "s3" {
    bucket         = "pragmalabstatebucket2024"
    dynamodb_table = "pragmalabstatebucket"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "us-east-1"
  }
}

