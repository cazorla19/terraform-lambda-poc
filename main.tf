terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.25.0"
    }
  }
}

provider "aws" {
  region = var.region
  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

// This backend bucket belongs to my AWS Account. Please change the name if you want to run it on your own one
terraform {
  backend "s3" {
    bucket = "cazorla19-test-tfstates"
    key    = "tfstates/blockchain-lambda.tf"
    region = "eu-west-1"
  }
}

// Declare the Lambda module to deploy all subsequent resources
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.34.0"

  publish = true

  function_name = "blockchain-lambda"
  description   = "Fetch the latest blocks from Blockchain API and send notifications to SNS afterwards"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  timeout       = 30

  destination_on_success = aws_sns_topic.blockchain_updates.arn

  source_path = [
    "${path.module}/app/index.py",
    {
       pip_requirements = "${path.module}/app/requirements.txt"
    }
  ]
}

// Create SNS topic
resource "aws_sns_topic" "blockchain_updates" {
  name = "blockchain-updates-topic"
}
