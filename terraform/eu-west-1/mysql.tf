resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "mysql" {
  subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mydbatf" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  name              = "wordpress"
  username          = "admin"
  password          = "changeme"
}
