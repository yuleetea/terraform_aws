// two public subnets and two private subnets
// one public/one private subnet in each region. Public will hold internet facing applications and private will hold database

# Public Subnet for us-east-1
resource "aws_subnet" "my_public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24" # Construct CIDR block based on each.value
  availability_zone = "us-east-1a"

  # Enable auto-assign public IPv4 addresses
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet-1"
  }
}

resource "aws_subnet" "my_public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24" # Construct CIDR block based on each.value
  availability_zone = "us-east-1b"

  # Enable auto-assign public IPv4 addresses
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet-2"
  }
}

resource "aws_subnet" "my_private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24" # Construct CIDR block based on each.value
  availability_zone = "us-east-1a"


  tags = {
    Name = "my-private-subnet-1"
  }
}

resource "aws_subnet" "my_private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24" # Construct CIDR block based on each.value
  availability_zone = "us-east-1b"


  tags = {
    Name = "my-private-subnet-2"
  }
}