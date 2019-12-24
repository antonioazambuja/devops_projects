provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_vpc" "example" {
    cidr_block = "172.17.0.0/16"
    tags = {
        Name   = "vpc-calc"
    }
}

resource "aws_internet_gateway" "example" {
    vpc_id = "${aws_vpc.example.id}"
    tags = {
        Name = "ig-example"
    }
}

resource "aws_route_table" "example" {
    vpc_id = "${aws_vpc.example.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.example.id}"
    }

    route {
        ipv6_cidr_block        = "::/0"
        egress_only_gateway_id = "${aws_egress_only_internet_gateway.example.id}"
    }

    tags = {
        Name = "rt-example"
    }
}

resource "aws_main_route_table_association" "example" {
    vpc_id         = "${aws_vpc.example.id}"
    route_table_id = "${aws_route_table.example.id}"
}

resource "aws_egress_only_internet_gateway" "example" {
    vpc_id = "${aws_vpc.example.id}"
}

resource "aws_subnet" "example-a" {
    availability_zone = "us-east-2a"
    cidr_block        = "172.17.0.0/20"
    vpc_id            = "${aws_vpc.example.id}"
    tags = {
        Name = "subnet"
    }
}

resource "aws_subnet" "example-b" {
  availability_zone = "us-east-2b"
  cidr_block        = "172.17.16.0/20"
  vpc_id            = "${aws_vpc.example.id}"
  tags = {
    Name = "subnet"
  }
}

resource "aws_subnet" "example-c" {
  availability_zone = "us-east-2c"
  cidr_block        = "172.17.32.0/20"
  vpc_id            = "${aws_vpc.example.id}"
  tags = {
    Name = "subnet"
  }
}

resource "aws_security_group" "example" {
  name = "asg-example"
  vpc_id = "${aws_vpc.example.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your-cidr-block"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["your-cidr-block"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self = "true"
  }
  tags = {
    Name = "asg-example"
  }
}

data "aws_ami" "example" {
    owners = ["self"]
    filter {
        name   = "name"
        values = ["example"]
    }
}

resource "aws_launch_configuration" "example" {
    image_id        = "${data.aws_ami.example.id}"
    name            = "lc-example"
    instance_type   = "t2.micro"
    key_name        = "key-name"
    security_groups = ["${aws_security_group.example.id}"]
    vpc_classic_link_id = "${aws_vpc.example.id}"
    user_data = <<-EOF
		#!/bin/bash

        systemctl start service-example
        systemctl enable service-example
	EOF
}

resource "aws_autoscaling_group" "example" {
    name                 = "ag-example"
    launch_configuration = "${aws_launch_configuration.example.name}"
    min_size             = 2
    max_size             = 4
    availability_zones   = ["${var.aws_region_config}"]
    load_balancers       = ["${aws_elb.example.id}"]
    tag {
        key                 = "Name"
        value               = "example"
        propagate_at_launch = true
    }
    vpc_zone_identifier = [
        "${aws_subnet.example-a.id}",
        "${aws_subnet.example-b.id}",
        "${aws_subnet.example-c.id}"
    ]
}

resource "aws_elb" "example" {
    name               = "elb-example"
    availability_zones = ["${var.aws_region_config}"]
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    instances = ["${aws_autoscaling_group.example}"]
    source_security_group = "${aws_security_group.example.id}"
    tags = {
        Name = "elb-example"
    }
}

resource "aws_autoscaling_attachment" "example-aa" {
  autoscaling_group_name = "${aws_autoscaling_group.example.id}"
  elb                    = "${aws_elb.example.id}"
}
