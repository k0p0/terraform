resource "aws_vpc" "main" {
  cidr_block       = "192.168.8.0/22"
  instance_tenancy = "dedicated"

  tags {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main-gw"
  }
}

resource "aws_route_table" "r-pub" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "main-r-pub"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.8.0/24"
  availability_zone = "eu-west-1a"

  tags {
    Name = "main-public-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.9.0/24"
  availability_zone = "eu-west-1b"

  tags {
    Name = "main-public-b"
  }
}

resource "aws_route_table_association" "route-a" {
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.r-pub.id}"
}

resource "aws_route_table_association" "route-b" {
  subnet_id      = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.r-pub.id}"
}

resource "aws_subnet" "private-a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.10.0/24"
  availability_zone = "eu-west-1a"

  tags {
    Name = "main-private-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.11.0/24"
  availability_zone = "eu-west-1b"

  tags {
    Name = "main-private-b"
  }
}

resource "aws_eip" "one" {}

resource "aws_eip" "two" {}

resource "aws_nat_gateway" "nat-gw-one" {
  allocation_id = "${aws_eip.one.id}"
  subnet_id     = "${aws_subnet.public-a.id}"

  tags {
    Name = "nat-gw-one"
  }
}

resource "aws_nat_gateway" "nat-gw-two" {
  allocation_id = "${aws_eip.two.id}"
  subnet_id     = "${aws_subnet.public-b.id}"

  tags {
    Name = "nat-gw-two"
  }
}

resource "aws_route_table" "r-priv-a" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw-one.id}"
  }

  tags {
    Name = "main-r-priv-a"
  }
}

resource "aws_route_table" "r-priv-b" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw-two.id}"
  }

  tags {
    Name = "main-r-priv-b"
  }
}

resource "aws_route_table_association" "route-priv-a" {
  subnet_id      = "${aws_subnet.private-a.id}"
  route_table_id = "${aws_route_table.r-priv-a.id}"
}

resource "aws_route_table_association" "route-priv-b" {
  subnet_id      = "${aws_subnet.private-b.id}"
  route_table_id = "${aws_route_table.r-priv-b.id}"
}
