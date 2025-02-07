provider "aws" {
  region = "us-east-1"  # Update this to the correct region
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # You can change this to your desired AZ
  map_public_ip_on_launch = true
}

# Attach route table to the subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "public_route_table_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Security Group for EC2 instance
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# EC2 Instance in the Public Subnet
resource "aws_instance" "web_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Replace with a valid Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

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

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false  # Ensure no uppercase characters are used
}

resource "aws_s3_bucket" "static_files" {
  bucket = "ultracloud5652-static-bucket-${random_string.bucket_suffix.result}"

  # Ensure the bucket name is lowercase and valid
  lifecycle {
    # prevent_destroy = true
  }
}
