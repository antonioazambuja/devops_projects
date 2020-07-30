provider "aws" {
    alias = "aws-${ar.REGION}"
    region = "${var.REGION}"
    assume_role {
        role_arn = "${var.ARN}"
    }
}

data "aws_vpc" "infrapoc" {
    filter {
        name   = "tag:Name"
        values = ["infrapoc"]
    }
    filter {
        name   = "tag:Project"
        values = ["poc"]
    }
}

data "aws_security_group" "infrapoc" {
    filter {
        name = "group-name"
        values = ["infrapoc"]
    }
    filter {
        name = "tag:Project"
        values = ["poc"]
    }
}

data "aws_subnet" "infrapoc" {
  filter {
    name   = "tag:Name"
    values = ["infrapoc-a"]
  }
  filter {
    name   = "tag:Project"
    values = ["poc"]
  }
}

data "aws_ami" "tema20-redis" {
    owners = ["self"]
    filter {
        name   = "name"
        values = ["Ubuntu Server 18.04 LTS (HVM) *"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
  }
}

resource "aws_instance" "infrapoc" {
    key_name               = "${KEY_PAIR_NAME}"
    instance_type          = "${INSTANCE_TYPE}"
    ami                    = "${data.aws_ami.infrapoc.id}"
    iam_instance_profile   = "${IAM_PROFILE_NAME}"
    vpc_security_group_ids = [
        "${data.aws_security_group.infrapoc.id}"
    ]
    subnet_id = "${data.aws_subnet.infrapoc.id}"
    tags = {
        Name = "infrapoc"
        Project = "poc"
    }
}
