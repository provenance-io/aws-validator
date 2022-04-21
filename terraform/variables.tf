variable "aws_account_id" {
  description = "The account ID associated with this account"
  type        = string
}

variable "personal_cidr" {
  description = "A personal cidr block that will be given security group access to ssh from"
  type        = string
}

variable "tmkms_pcr0" {
  description = "Tmkms PCR0 attestation"
  type        = string

  default = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
}

variable "tmkms_pcr4" {
  description = "Tmkms PCR4 attestation"
  type        = string

  default = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
}
