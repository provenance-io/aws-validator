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

// TODO remove if able to
resource "aws_iam_policy" "tmkms_kms_all" {
  name = "demo_tmkms_kms_all"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.tmkms.arn
      },
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.tmkms.arn
        Condition = {
          StringEqualsIgnoreCase = {
            "kms:RecipientAttestation:PCR0" : var.tmkms_pcr0,
            "kms:RecipientAttestation:PCR4" : var.tmkms_pcr4
          }
        }
      }
    ]
  })
}

// resource "aws_iam_role_policy_attachment" "tmkms_kms" {
//   role       = aws_iam_role.tmkms.name
//   policy_arn = aws_iam_policy.tmkms_kms_all.arn
// }
