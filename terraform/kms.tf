data "aws_iam_policy_document" "tmkms_key" {
  statement {
    sid = "Enable root account permissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "Encrypt from instance only"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.tmkms.arn]
    }

    actions = [
      "kms:Encrypt",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "Decrypt from nitro enclave only"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.tmkms.arn]
    }

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEqualsIgnoreCase"
      variable = "kms:RecipientAttestation:PCR0"

      values = [var.tmkms_pcr0]
    }

    condition {
      test     = "StringEqualsIgnoreCase"
      variable = "kms:RecipientAttestation:PCR4"

      values = [var.tmkms_pcr4]
    }
  }
}

resource "aws_kms_key" "tmkms" {
  description             = "KMS key for tkmkms"
  deletion_window_in_days = 30

  policy = data.aws_iam_policy_document.tmkms_key.json
}

resource "aws_kms_alias" "tmkms" {
  name          = "alias/demo-tmkms"
  target_key_id = aws_kms_key.tmkms.key_id
}
