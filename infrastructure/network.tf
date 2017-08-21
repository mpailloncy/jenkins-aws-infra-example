resource "aws_vpc" "vpc_jenkins" {
  cidr_block = "${var.vpc_cidr}"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Jenkins VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.vpc_jenkins.id}"
  cidr_block = "${var.public_subnet_cidr}"

  map_public_ip_on_launch = true

  availability_zone = "${var.aws_availability_zone}"

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.vpc_jenkins.id}"
  cidr_block = "${var.private_subnet_cidr}"

  availability_zone = "${var.aws_availability_zone}"

  tags = {
    Name = "Private subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc_jenkins.id}"

  tags {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.vpc_jenkins.id}"
}

resource "aws_route" "nat_igw" {
  route_table_id         = "${aws_route_table.nat.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_route_table.nat"]
}

resource "aws_route_table_association" "nat" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.nat.id}"
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc_jenkins.id}"

  tags {
    Name = "Private route table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc_jenkins.id}"
}

resource "aws_security_group" "default_private" {
  name   = "default-private"
  vpc_id = "${aws_vpc.vpc_jenkins.id}"
}

resource "aws_security_group" "default_public" {
  name   = "default-public"
  vpc_id = "${aws_vpc.vpc_jenkins.id}"
}

resource "aws_security_group" "jenkins_agent_security_group" {
  name = "jenkins_agent_security_group"

  vpc_id = "${aws_vpc.vpc_jenkins.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc_jenkins.cidr_block}"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${aws_vpc.vpc_jenkins.cidr_block}"]
  }
}

resource "aws_security_group" "web_inbound_security_group" {
  name = "web_inbound_security_group"

  vpc_id = "${aws_vpc.vpc_jenkins.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${aws_vpc.vpc_jenkins.cidr_block}"]
  }
}

// TODO - improve the provisioning through a bastion machine
/*resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.vpc_jenkins.id}"

  description = "Allow SSH to bastion host"

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

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/
