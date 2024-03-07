provider "aws" {
  region = "us-east-1"
  // the profile is found in the ~/.aws/credentials file and im setting the region here
  profile = "my_aws_profile"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  # configured backend to store the terraform.tfstate file in s3 bucket called terraform-bucket-for-state-s3
  backend "s3" {
    bucket         = "terraform-bucket-for-state-s3"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # dynamodb_table = "terraform_locks"

    # Specify the profile if you're using AWS credentials profile
    profile = "my_aws_profile"
  }

  required_version = ">= 1.2.0"
}

# Create S3 bucket
# When you create an s3 bucket, the name must be UNIQUE and it must not contain underscores
# I needed to create this s3 bucket first before i configured the backend. Not sure how I can create both at the same time :/
resource "aws_s3_bucket" "terraform-bucket-for-state-s3" {
  bucket = "terraform-bucket-for-state-s3"

  tags = {
    Name = "Terraform State Bucket for tfstate"
  }
}



# Define VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"

  # Enable DNS support and DNS hostnames
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}

# Define Internet Gateway (IGW)
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Define Public Subnet
resource "aws_subnet" "my_public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24" # Specify a CIDR block for the public subnet
  availability_zone = "us-east-1a"

  # Enable auto-assign public IPv4 addresses, need this to ssh and access the jenkins instance. Need to make sure the route table and subnet association is done correctly. Make sure it is public facing and attached the igw
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

# Define Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "my_route_association" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}


# Define Security Group
resource "aws_security_group" "my_terraform_sg" {
  name        = "my_terraform_sg"
  description = "Security group for my VPC"
  vpc_id      = aws_vpc.my_vpc.id

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["100.34.2.23/32"]  // Allow SSH access from my IP only
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow HTTPS access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // 8080 for jenkins
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# i'm creating a resource that is an aws_instance, CALLED app_server
resource "aws_instance" "app_server" {
  ami           = "ami-07761f3ae34c4478d"
  instance_type = "t2.micro"
  # the first argument the file method takes is the path to the file
  user_data = file("./ec2_bash_script.sh")
  # this is for the key pair, if the keypair exists in same directory then you dont need to add the .pem extension for it
  key_name      = "mykeypair"

  # depends_on - used to make sure the app_server instance is only created when my vpc is created. This is so that it can connect to the SG. This is called creating a dependancy in Terraform
  depends_on = [aws_vpc.my_vpc, aws_subnet.my_public_subnet]

  // A note on subnet_id and security groups. I needed to add the .id to the end of both to directly reference the resource. Just saying aws_subnet.my_subnet was not enough. But now I'm able to create the vpc and sg's before the ec2 instance now. 

  // add subnet
  subnet_id = aws_subnet.my_public_subnet.id

  // reference security group and place ec2 instance inside of it, has permissions to ssh/http/https/and port forwarding 8080 for jenkins
  security_groups = [aws_security_group.my_terraform_sg.id]


  tags = {
    Name = "TerraformServer"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("./mykeypair.pem") # Replace with the path to your key pair's private key file
  }
}





// next steps: store state file in s3 bucket
// setup the jenkins environment to do the same thing as the app environment with github push 

