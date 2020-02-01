provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "example" {
    key_name      = "${var.key_name}"
    instance_type = "${var.instance_type}"
    ami           = "${var.ami_id}"
    associate_public_ip_address = true
    tags = {
        Name = "example"
    }
}
