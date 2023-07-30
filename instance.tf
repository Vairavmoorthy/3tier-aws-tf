resource "aws_instance" "ubuntu_20" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point1"
  }
}
resource "aws_instance" "ubuntu_20a" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point2"
  }
}