variable "create-elb" {
  type    = string
  default = "true"
}

resource "aws_elb" "krystian-buildit" {
  count            = var.create-elb == "true" ? 1 : 0
  name               = "krystian-buildit-terraform-elb"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  listener {
    instance_port     = 31846
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:31846/"
    interval            = 30
  }

  instances                   = [aws_instance.microk8s.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "krystian-buildit-terraform-elb"
  }
}
