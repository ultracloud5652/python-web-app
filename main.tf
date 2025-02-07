provider "aws" {
  region = "us-east-1"  # Updated to the correct region (us-east-1)
}

# VPC Resource
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet Resource
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Use the correct AZ for us-east-1
  map_public_ip_on_launch = true
}

# Security Group Resource
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance Resource
resource "aws_instance" "web_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Ubuntu AMI ID for us-east-1 region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    # Pull Docker image from Docker Hub
    docker pull ultracloud5652/python-web-app:latest
    docker run -d -p 80:80 ultracloud5652/python-web-app:latest
  EOF

  tags = {
    Name = "WebServer"
  }
}

# S3 Bucket Resource (with unique name)
resource "aws_s3_bucket" "static_files" {
  bucket = "ultracloud5652-static-bucket-${random_string.bucket_suffix.result}"
}

# Random string resource to ensure unique S3 bucket name
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
}
