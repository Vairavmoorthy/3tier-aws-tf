# Provider
provider "aws" {
  region = var.region
}
# Defining VPC
resource "aws_vpc" "cloudvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "3tvpc"
  }
}
# Defining Subnet for instance
resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.availability_zone
    tags = {
      Name = "instance_subnet1"
    }
}
# Defining Subnet for instance 2
resource "aws_subnet" "publicsubnet2" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.availability_zone2
    tags = {
      Name = "instance_subnet2"
    }
}
# Defining Subnet for Applications
resource "aws_subnet" "applicationsubnet" {
   vpc_id = aws_vpc.cloudvpc.id
  cidr_block = var.subnet2_cidr
  availability_zone = var.availability_zone2
  tags = {
      Name = "Application_subnet1"
    }
}
resource "aws_subnet" "applicationsubnet2" {
   vpc_id = aws_vpc.cloudvpc.id
  cidr_block = var.subnet3_cidr
  availability_zone = var.availability_zone
  tags = {
      Name = "Application_subnet2"  
       }
}
# Defining Subnet for databases
resource "aws_subnet" "database_subnet" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet4_cidr
    availability_zone = var.availability_zone2
    tags = {
      Name = "Database_subnet2"  
       }
}
# Defining Subnet for databases
resource "aws_subnet" "database_subnet2" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet5_cidr
    availability_zone = var.availability_zone
    tags = {
      Name = "Database_subnet2"   
       }
}
# Defining subnet groups
resource "aws_db_subnet_group" "db_subnets" {
  subnet_ids = [aws_subnet.database_subnet.id,aws_subnet.database_subnet2.id]
  tags = {
    Name = "db_subnet_group"
  }
}
# Defining IGW
resource "aws_internet_gateway" "awsigt" {
   vpc_id = aws_vpc.cloudvpc.id
}
# Defining Route table
resource "aws_route_table" "Public_rt" {
  vpc_id = aws_vpc.cloudvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awsigt.id
  }
}
# Defing routetable association 
resource "aws_route_table_association" "rt1" {
  subnet_id = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.Public_rt.id
}
# Defing routetable association 
resource "aws_route_table_association" "rt2" {
  subnet_id = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.Public_rt.id
}
