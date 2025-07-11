terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

/*variable "sample_public_key" {
    description = "value of public key"
    type = string
}

variable "region" {
    description = "Enter location of the server"
    default = "us-east-1"
  
}*/

provider "aws" {
  # Configuration options
  #  profile = "default" 
  region = var.region
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "sample_key" {
    key_name = "deployer-key"
    public_key = var.sample_public_key

    tags = {
        Name = "sample_public_key"
    }
}

resource "aws_instance" "new_server" {
    ami = data.aws_ami.latest_ubuntu.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.sample_key.key_name


    tags = {
    Name = "HelloWorld"
    }
}
