provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

data "aws_security_group" "example" {
    filter {
        name = "group-name"
        values = ["asg-example"]
    }
}

data "aws_ami" "example" {
    owners = ["self"]
    filter {
        name   = "name"
        values = ["value"]
    }
}

data "aws_vpc" "example" {
    filter {
        name   = "tag:Name"
        values = ["vpc-example"]
    }
}

data "aws_subnet" "example" {
    filter {
        name   = "tag:Name"
        values = ["example-a"]
    }
}
