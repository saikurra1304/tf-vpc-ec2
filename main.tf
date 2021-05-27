# AWS Provider TERRAFORM

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure AWS Provider Authentication
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"

}

# Create resource - VPC
resource "aws_vpc" "ibm" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "IBM"
  }
}

# Subnet creation - S
resource "aws_subnet" "ibm-web-1" {
  vpc_id                  = aws_vpc.ibm.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "IBM-Web-1"
  }
}


# Subnet creation - S
resource "aws_subnet" "ibm-web-2" {
  vpc_id                  = aws_vpc.ibm.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "IBM-Web-2"
  }
}

# Subnet creation - S
resource "aws_subnet" "ibm-db-1" {
  vpc_id                  = aws_vpc.ibm.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "IBM-DB-1"
  }
}

# Subnet creation - S
resource "aws_subnet" "ibm-db-2" {
  vpc_id                  = aws_vpc.ibm.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "IBM-DB-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ibm_igw" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-IGW"
  }
}

# Pub Route Table
resource "aws_route_table" "ibm-pub-rtb" {
  vpc_id = aws_vpc.ibm.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm_igw.id
  }

  tags = {
    Name = "IBM-PUB-RTB"
  }
}

# PVT Route Table
resource "aws_route_table" "ibm-pvt-rtb" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-PVT-RTB"
  }
}

# Pub Subnet Association
resource "aws_route_table_association" "ibm-pub1" {
  subnet_id      = aws_subnet.ibm-web-1.id
  route_table_id = aws_route_table.ibm-pub-rtb.id
}

resource "aws_route_table_association" "ibm-pub2" {
  subnet_id      = aws_subnet.ibm-web-2.id
  route_table_id = aws_route_table.ibm-pub-rtb.id
}

# Pvt Subnet Association
resource "aws_route_table_association" "ibm-pvt1" {
  subnet_id      = aws_subnet.ibm-db-1.id
  route_table_id = aws_route_table.ibm-pvt-rtb.id
}

resource "aws_route_table_association" "ibm-pvt2" {
  subnet_id      = aws_subnet.ibm-db-2.id
  route_table_id = aws_route_table.ibm-pvt-rtb.id
}
