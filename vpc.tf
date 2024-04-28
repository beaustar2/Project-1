# Create VPC
resource "aws_vpc" "javawebapp-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    "Name" = "Javawebapp vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "javawebapp-public-subnet" {
  vpc_id                  = aws_vpc.javawebapp-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Javawebapp public subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "javawebapp-private-subnet" {
  vpc_id                  = aws_vpc.javawebapp-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Javawebapp private subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "javaweb-igw" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "Javawebapp igw"
  }
}

# Create Public Route Table
resource "aws_route_table" "javawebapp-public-route-table" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "Javawebapp public route table"
  }
}

# Create Private Route Table
resource "aws_route_table" "javawebapp-private-route-table" {
  vpc_id = aws_vpc.javawebapp-vpc.id
  tags = {
    Name = "Javawebapp private route table"
  }
}

# Create Route in Route Table for Internet Access
resource "aws_route" "javawebapp-public-route" {
  route_table_id         = aws_route_table.javawebapp-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.javaweb-igw.id
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "javawebapp-public-route-table-associate" {
  route_table_id = aws_route_table.javawebapp-public-route-table.id
  subnet_id      = aws_subnet.javawebapp-public-subnet.id
}

# Associate the Route Table with the Private Subnet
resource "aws_route_table_association" "javawebapp-private-route-table-associate" {
  route_table_id = aws_route_table.javawebapp-private-route-table.id
  subnet_id      = aws_subnet.javawebapp-private-subnet.id
}

# Create Security Group
resource "aws_security_group" "javaweb-sg" {
  name        = "Javaweb SSH & HTTPD"
  description = "Allow SSH & HTTPD inbound traffic"
  vpc_id      = aws_vpc.javawebapp-vpc.id

  ingress {
    description = "Allow SSH from port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPD from port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "javaweb-SG"
  }
}