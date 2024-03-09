Terraform side project

Refer to [aws_ci_cd](https://github.com/yuleetea/aws-ci-cd-jenkins), where I create a ci-cd pipeline for a simple python flask application. This repo is to automate the infrastructure side.

This terraform has:
VPC - route tables, subnets, security groups that allows ssh, http, https, and 8080 port forwarding
2 public and 2 private subnets
A launch template with bootstrapped ec2 instances that are in the VPC network
Auto scaling group

To be added:
Application Load Balancer
RDS Database in private subnet
ECS/EKS integration
Integrate CloudWatch to moniter clusters/instances
AWS Lambda to grab cloudwatch logs
