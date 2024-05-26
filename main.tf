

provider "aws" {
  region = var.region
  
}
variable "region" {}
variable "dev_vpc1_cidr_block" {}  
variable "dev_subnet1_cidr_block" {}  
variable "environment" {}

 #------------------- vpc ------------------------
resource "aws_vpc" "test_vpc" {
  cidr_block           = var.dev_vpc1_cidr_block
  enable_dns_hostnames = "true"
  tags = {
    Name = "test_vpc"
    Environment = "${var.environment}"
  }
}

#------------------- public subnet 1 ------------------------

resource "aws_subnet" "public1_test" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.dev_subnet1_cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name = "public1_test"
    Environment = "${var.environment}"
  }
}

 #------------------- IGW ------------------------
resource "aws_internet_gateway" "test_gw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test_gw"
    Environment = "${var.environment}"
  }
}

#------------------- public route table ------------------------

resource "aws_route_table" "public_iti" {
  vpc_id = aws_vpc.test_vpc.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gw.id
  }
 route {
    cidr_block = var.dev_vpc1_cidr_block
    gateway_id = "local"
    }
}

