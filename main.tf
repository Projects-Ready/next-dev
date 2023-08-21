#resource and backend
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
#backend s3 bucket 
backend "s3" {
  bucket = "kobsdemo"
  key = "tfstate"
  region = "us-east-1"
 }
}

#spin ec2-instances for Jenkins, Docker, Baston host, count 3.
provider "aws" {
  region = "us-east-1"
  }

resource "aws_instance" "Important_servers" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair
  monitoring = true
  ebs_optimized = true
  http_tokens   = "required"
  encrypted     = true
  Name = "dynamic-instance-${count.index}"
  }