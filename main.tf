# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN S3 BUCKET AND DYNAMODB TABLE TO USE AS A TERRAFORM BACKEND
# Source: https://github.com/gruntwork-io/intro-to-terraform/tree/master/s3-backend (accessed 15/02-2020)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# SET UP AWS PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region     = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# ------------------------------------------------------------------------------
# CREATE THE S3 BUCKET
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "gkc-bproject-terraform-backend" # Bucket name has to globally unique amongst all AWS users

  # Enables full revision history of the state file
  versioning {
    enabled = true
  }

  # Enable server-side encryption to ensure store file is encrypted on disk in S3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  #tfsec:ignore:AWS002
}

# ------------------------------------------------------------------------------
# CREATE THE DYNAMODB TABLE
# Key-value store used for locking. Supports strongly-consistent reads and
# conditional writes, which is needed for distributed locking.
# ------------------------------------------------------------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "gkc-bproject-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # Primary key

  attribute {
    name = "LockID"
    type = "S"
  }
}

# ------------------------------------------------------------------------------
# CREATE S3 BUCKET PUBLIC ACCESS BLOCK
# Set up permissions to block all public access to S3 bucket.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
