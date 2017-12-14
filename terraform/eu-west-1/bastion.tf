resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = "ssh-rsa ADD YOUR SSH KEY PUB"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_eip" "bastion-eip" {}

resource "aws_instance" "bastion" {
  ami           = "${var.image}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.bastion-key.key_name}"

  tags {
    Name = "bastion-ec2"
  }
}

resource "aws_eip_association" "eip_asso_bastion" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion-eip.id}"
}

output "bastion ip public" {
  value = "${aws_instance.bastion.public_ip}"
}
