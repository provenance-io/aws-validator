# Provenance Node Base AMI

This image can be used for any Provenance node configuration, e.g., public node, seed node, validator node, etc.

The AMI is built and released to all US AWS regions, but to manually build the AMI, the following command can be used.

```bash
AWS_REGION=<aws region> AWS_PACKER_VPC=<valid vpc reference> AWS_PACKER_SUBNET=<valid subnet reference> packer build provision.json
```
