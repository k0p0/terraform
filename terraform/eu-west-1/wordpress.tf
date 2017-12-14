resource "aws_security_group" "allow_wordpress" {
  name        = "allow_wordpress"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_ebs_volume" "wordpress-ebs" {
    availability_zone = "eu-west-1a"
    size = 10
    tags {
        Name = "ebs-wordpress"
    }
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = "${aws_ebs_volume.wordpress-ebs.id}"
  instance_id = "${aws_instance.wordpress_01.id}"
}




data "template_file" "wordpress" {
  template = "${file("wordpress.sh")}"

  vars {
    rds_endpoint = "${element(split(":", aws_db_instance.mydbatf.endpoint), 0)}"
    rds_username = "admin"
    rds_password = "changeme"
  }
}

resource "aws_instance" "wordpress_01" {

  user_data = "${data.template_file.wordpress.rendered}"
  ami           = "${var.image}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1a"

  key_name = "${aws_key_pair.bastion-key.key_name}"

  tags {
    Name = "wordpress-ec2"
  }

}



