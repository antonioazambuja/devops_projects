provider "aws" {
    region     = "${var.AWS_REGION}"
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_vpc" "infrapoc" {
    cidr_block = "10.51.0.0/16"
    tags = {
        Name = "infrapoc"
        Project = "poc"
    }
}

resource "aws_internet_gateway" "infrapoc" {
    vpc_id = "${aws_vpc.infrapoc.id}"
    tags = {
        Name = "infrapoc"
        Project = "poc"
    }
}

resource "aws_route_table" "infrapoc" {
    vpc_id = "${aws_vpc.infrapoc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.infrapoc.id}"
    }

    route {
        ipv6_cidr_block        = "::/0"
        egress_only_gateway_id = "${aws_egress_only_internet_gateway.infrapoc.id}"
    }

    tags = {
        Name = "infrapoc"
        Project = "poc"
    }
}

resource "aws_main_route_table_association" "infrapoc" {
    vpc_id         = "${aws_vpc.infrapoc.id}"
    route_table_id = "${aws_route_table.infrapoc.id}"
}

resource "aws_egress_only_internet_gateway" "infrapoc" {
    vpc_id = "${aws_vpc.infrapoc.id}"
}

resource "aws_subnet" "infrapoc-a" {
    availability_zone = "us-east-1a"
    cidr_block        = "10.51.0.0/20"
    vpc_id            = "${aws_vpc.infrapoc.id}"
    tags = {
        Name = "infrapoc-a"
        Project = "poc"
    }
}

resource "aws_subnet" "infrapoc-b" {
    availability_zone = "us-east-1b"
    cidr_block        = "10.51.16.0/20"
    vpc_id            = "${aws_vpc.infrapoc.id}"
    tags = {
        Name = "infrapoc-b"
        Project = "poc"
    }
}

resource "aws_subnet" "infrapoc-c" {
    availability_zone = "us-east-1c"
    cidr_block        = "10.51.32.0/20"
    vpc_id            = "${aws_vpc.infrapoc.id}"
    tags = {
        Name = "infrapoc-c"
        Project = "poc"
    }
}

resource "aws_security_group" "infrapoc" {
  name = "infrapoc"
  vpc_id = "${aws_vpc.infrapoc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.51.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "infrapoc"
    Project = "poc"
  }
}
