resource "aws_lb" "ext-alb" {
  name               = "External-Lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.appsec.id]
  subnets            = [aws_subnet.publicsubnet.id, aws_subnet.publicsubnet2.id]
}

resource "aws_lb_target_group" "elb-target" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudvpc.id
}

resource "aws_lb_target_group_attachment" "attached" {
  target_group_arn = aws_lb_target_group.elb-target.arn
  target_id        = aws_instance.ubuntu_20.id
  port             = 80
  depends_on       = [aws_instance.ubuntu_20]
}

resource "aws_lb_target_group_attachment" "attached1" {
  target_group_arn = aws_lb_target_group.elb-target.arn
  target_id        = aws_instance.ubuntu_20a.id
  port             = 80
  depends_on       = [aws_instance.ubuntu_20a]
}

resource "aws_lb_listener" "ext-elb" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-target.arn
  }
}
