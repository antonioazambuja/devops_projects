provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_security_group" "example" {
  name = "example"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-example"
  }
}


resource "aws_instance" "example" {
    ami                    = "${var.ami_id}"
    key_name               = "${var.key_name}"
    instance_type          = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.example.id}"]
    tags = {
        Name = "example"
    }
}
