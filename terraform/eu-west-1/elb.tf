resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_http"
  }
}

resource "aws_elb" "bar" {
  name               = "atelier-terraform-elb"
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-admin/install.php"
    interval            = 30
  }

  tags {
    Name = "atelier-terraform-elb"
  }
}


resource "aws_elb_attachment" "baz" {
  elb      = "${aws_elb.bar.id}"
  instance = "${aws_instance.wordpress_01.id}"
}

output "wordpress_dns_name" {
  value = "${aws_elb.bar.dns_name}"
}
