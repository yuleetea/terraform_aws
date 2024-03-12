Terraform side project

Refer to [aws_ci_cd](https://github.com/yuleetea/aws-ci-cd-jenkins), where I create a ci-cd pipeline for a simple python flask application. This repo is to automate the infrastructure side.

This terraform has: <br>
VPC - route tables, subnets, security groups that allows ssh, http, https, and 8080 port forwarding <br>
MySQL rds DB with 3306 port forwarding in public subnet <br>
2 public and 2 private subnets <br>
A launch template with bootstrapped ec2 instances that are in the VPC network <br>
Auto scaling group <br>
S3 bucket that holds the terraform.tfstate file. Need to set up versioning for it - todo <br>

To be added: <br>
Application Load Balancer with listeners and target groups <br>
ECS/EKS integration <br>
Integrate CloudWatch to moniter clusters/instances <br>
AWS Lambda to grab cloudwatch logs <br>
