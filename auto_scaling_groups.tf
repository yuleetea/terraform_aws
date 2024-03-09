resource "aws_autoscaling_group" "asg" {
  name                      = "auto-scaling-group"
  launch_template {
    id      = aws_launch_template.ec2_lt_public.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 2
  // takes subnet ID to launch instances in
  vpc_zone_identifier       = [aws_subnet.my_public_subnet_1.id, aws_subnet.my_public_subnet_2.id]
  # Other configurations for your ASG...
}
