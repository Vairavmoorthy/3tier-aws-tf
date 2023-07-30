# Defining region 
variable "region" {
  default = "ap-south-1"
}
# Defining availability_zone 1
variable "availability_zone" {
  default = "ap-south-1a"
}
# Defining availability_zone 2
variable "availability_zone2" {
  default = "ap-south-1b"
}
# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# Defining CIDR Block for 1st Subnet
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}
# Defining CIDR Block for 2ndSubnet
variable "subnet1_cidr" {
  default = "10.0.2.0/24"
}
# Defining CIDR Block for 3rd Subnet
variable "subnet2_cidr" {
  default = "10.0.3.0/24"
}
# Defining CIDR Block for 4th Subnet
variable "subnet3_cidr" {
  default = "10.0.4.0/24"
}
# Defining CIDR Block for 5th Subnet
variable "subnet4_cidr" {
  default = "10.0.5.0/24"
}
# Defining CIDR Block for 6th Subnet
variable "subnet5_cidr" {
  default = "10.0.6.0/24"
}