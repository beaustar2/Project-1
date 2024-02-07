# Resource Block
# Resource-1: Create VPC
resource "aws_vpc" "javawebapp-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "javawebapp vpc"
  }
}
# Resource-2: Create Public Subnets
resource "aws_subnet" "javawebapp-public-subnet" {
  vpc_id                  = aws_vpc.javawebapp-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "javawebapp public subnet1"
  }
}
# Resource-3: Create Private Subnets
resource "aws_subnet" "javawebapp-private-subnet" {
  vpc_id                  = aws_vpc.javawebapp-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "javawebapp private subnet1"
  }
}
# Resource-4: Create Internet Gateway
resource "aws_internet_gateway" "javawebapp-igw" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "javawebapp igw"
  }
}
# Resource 5: Create Public Route Table
resource "aws_route_table" "javawebapp-public-route-table" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "javawebapp public route table"
  }
}
# Resource 6: Create Private Route Table
resource "aws_route_table" "javawebapp-private-route-table" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "javawebapp private route table"
  }
}

# Resource-7: Create Route in Route Table for Internet Access
resource "aws_route" "javawebapp-public-route" {
  route_table_id         = aws_route_table.javawebapp-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.javawebapp-igw.id
}

# Resource-8: Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "javawebapp-public-route-table-associate" {
  route_table_id = aws_route_table.javawebapp-public-route-table.id
  subnet_id      = aws_subnet.javawebapp-public-subnet.id
}

# Resource-9: Associate the Route Table with the Private Subnet
resource "aws_route_table_association" "javawebapp-private-route-table-associate" {
  route_table_id = aws_route_table.javawebapp-private-route-table.id
  subnet_id      = aws_subnet.javawebapp-private-subnet.id
}
