provider "aws" {
    region     = "${var.AWS_REGION}"
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_iam_role" "infrapoc" {
  name     = "bastion_infrapoc"
  path     = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "infrapoc" {
  name     = "bastion_infrapoc"
  role     = "${aws_iam_role.role.name}"
}

resource "aws_iam_policy" "infrapoc_ec2_full_access" {
  name        = "infrapoc_ec2_full_acess"
  description = "EC2 Full Access infrapoc policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "infrapoc_ec2_full_access" {
  role       = "${aws_iam_role.infrapoc.name}"
  policy_arn = "${aws_iam_policy.infrapoc_ec2_full_access.arn}"
}

resource "aws_iam_policy" "infrapoc_s3_full_access" {
  name        = "infrapoc"
  description = "S3 Full Access infrapoc policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "infrapoc_s3_full_access" {
  role       = "${aws_iam_role.infrapoc.name}"
  policy_arn = "${aws_iam_policy.infrapoc_s3_full_access.arn}"
}
