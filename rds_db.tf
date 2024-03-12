resource "aws_db_instance" "rds_terraform" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true  # Make the RDS instance publicly accessible

  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]  # Specify the security group(s) for your RDS instance
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.id
}