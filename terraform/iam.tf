resource "aws_iam_instance_profile" "tmkms" {
  name = "demo_tmkms_instance_profile"
  role = aws_iam_role.tmkms.name
}

resource "aws_iam_role" "tmkms" {
  name = "demo_tmkms_role"
  path = "/"

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
