resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.my_public_subnet_1.id, aws_subnet.my_public_subnet_2.id]  # Specify the subnet IDs where you want to deploy your ALB
  security_groups    = [aws_security_group.my_terraform_sg.id]  # Specify the security group(s) for your ALB

  enable_deletion_protection = false  # (Optional) Set to true to enable deletion protection

  tags = {
    Name = "MyALB"
  }
}
