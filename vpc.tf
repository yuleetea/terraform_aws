# Define VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  # Enable DNS support and DNS hostnames
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
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

# Associate Route Table with Subnet East 1a
resource "aws_route_table_association" "my_route_association_east" {
  subnet_id      = aws_subnet.my_public_subnet_1.id
  route_table_id = aws_route_table.my_route_table.id
}

# Associate Route Table with Subnet East 1b
resource "aws_route_table_association" "my_route_association_east2" {
  subnet_id      = aws_subnet.my_public_subnet_2.id
  route_table_id = aws_route_table.my_route_table.id
}