# Terraform – AWS S3 remote state setup
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.69.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.69.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_access\_key | Access key of AWS credentials | `string` | n/a | yes |
| aws\_secret\_key | Secret key of AWS credentials | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb\_table\_name | The name of the DynamoDB table |
| s3\_bucket\_arn | The ARN of the S3 bucket |
