output "lb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "aws_instance_ubuntu_20" {
  value = aws_instance.ubuntu_20.public_ip
}

output "aws_instance_ubuntu_20_1" {
  value = aws_instance.ubuntu_20a.public_ip
}
