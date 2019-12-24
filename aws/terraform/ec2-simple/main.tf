provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}


resource "aws_vpc" "example" {
    cidr_block = "172.19.0.0/16"
    tags = {
        Name   = "vpc"
    }
}

resource "aws_subnet" "example" {
    availability_zone = "us-east-2a"
    cidr_block        = "172.19.0.0/20"
    vpc_id            = "${aws_vpc.example.id}"
    tags = {
        Name   = "subnet"
    }
}

resource "aws_security_group" "example" {
  name   = "asg-example"
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

resource "aws_instance" "example" {
    key_name               = "example"
    instance_type          = "t2.micro"
    ami                    = "${data.aws_ami.example.id}"
    vpc_security_group_ids = [
        "${aws_security_group.example.id}",
        "${aws_vpc.example.id}"
    ]
    subnet_id = "${aws_subnet.example.id}"
    associate_public_ip_address = false
    availability_zone = "${var.aws_region_config}"
    tags = {
        Name = "example"
    }
    user_data = <<-EOF
		#!/bin/bash
        
        systemctl start 
        systemctl enable 
	EOF
}

resource "aws_elb" "example" {
    name                  = "elb-example"
    instances             = [
        "${aws_instance.example-master.id}",
        "${aws_instance.example-slave.id}"
    ]
    availability_zones    = ["${var.aws_region_config}"]
    source_security_group = "${aws_security_group.tema20-consul.id}"
    subnets = [
        "${aws_subnet.example.id}"
    ]
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    security_groups       = ["${aws_security_group.example.id}"]
}
