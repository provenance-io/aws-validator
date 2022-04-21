output "tmkms_kms_key_id" {
  value = aws_kms_key.tmkms.key_id
}

output "tmkms_kms_key_alias" {
  value = aws_kms_alias.tmkms.name
}
