# Create S3 bucket
# When you create an s3 bucket, the name must be UNIQUE and it must not contain underscores
# I needed to create this s3 bucket first before i configured the backend. Not sure how I can create both at the same time :/
resource "aws_s3_bucket" "terraform-bucket-for-state-s3" {
  bucket = "terraform-bucket-for-state-s3"

  tags = {
    Name = "Terraform State Bucket for tfstate"
  }
}

# i'm creating a resource that is an aws_instance, CALLED app_server_e, in the east region
resource "aws_instance" "app_server_e" {
  ami           = "ami-07761f3ae34c4478d"
  instance_type = "t2.micro"
  # the first argument the file method takes is the path to the file
  user_data = file("./ec2_bash_script.sh")
  # this is for the key pair, if the keypair exists in same directory then you dont need to add the .pem extension for it
  key_name = "mykeypair"

  # depends_on - used to make sure the app_server instance is only created when my vpc is created. This is so that it can connect to the SG. This is called creating a dependancy in Terraform
  depends_on = [aws_vpc.my_vpc, aws_subnet.my_public_subnet_1]

  // A note on subnet_id and security groups. I needed to add the .id to the end of both to directly reference the resource. Just saying aws_subnet.my_subnet was not enough. But now I'm able to create the vpc and sg's before the ec2 instance now. 

  // add subnet
  subnet_id = aws_subnet.my_public_subnet_1.id

  // reference security group and place ec2 instance inside of it, has permissions to ssh/http/https/and port forwarding 8080 for jenkins
  security_groups = [aws_security_group.my_terraform_sg.id]

  availability_zone = "us-east-1a" # Specify the availability zone within the desired region

  tags = {
    Name = "TerraformServerEast"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("./mykeypair.pem") # Replace with the path to your key pair's private key file
  }
}

# i'm creating a resource that is an aws_instance, CALLED app_server_e2, in the east 1b region
resource "aws_instance" "app_server_e2" {
  ami           = "ami-07761f3ae34c4478d"
  instance_type = "t2.micro"
  # the first argument the file method takes is the path to the file
  user_data = file("./ec2_bash_script.sh")
  # this is for the key pair, if the keypair exists in same directory then you dont need to add the .pem extension for it
  key_name = "mykeypair"

  # depends_on - used to make sure the app_server instance is only created when my vpc is created. This is so that it can connect to the SG. This is called creating a dependancy in Terraform
  depends_on = [aws_vpc.my_vpc, aws_subnet.my_public_subnet_2]

  // A note on subnet_id and security groups. I needed to add the .id to the end of both to directly reference the resource. Just saying aws_subnet.my_subnet was not enough. But now I'm able to create the vpc and sg's before the ec2 instance now. 

  // add subnet
  subnet_id = aws_subnet.my_public_subnet_2.id

  // reference security group and place ec2 instance inside of it, has permissions to ssh/http/https/and port forwarding 8080 for jenkins
  security_groups = [aws_security_group.my_terraform_sg.id]

  availability_zone = "us-east-1b" # Specify the availability zone within the desired region


  tags = {
    Name = "TerraformServerEast1b"
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

