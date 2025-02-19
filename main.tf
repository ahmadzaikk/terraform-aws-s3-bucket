resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  count         = var.enabled ? 1 : 0
  force_destroy = var.force_destroy
  tags = merge(var.tags, tomap({"Name" = var.bucket}))
}
#
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = join("", aws_s3_bucket.this.*.id)

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_arn
      sse_algorithm     = var.sse_algorithm
    }
  }
}
#
resource "aws_s3_bucket_versioning" "this" {
  bucket = join("", aws_s3_bucket.this.*.id)
  versioning_configuration {
    status = var.versioning_enabled
  }
}
#
resource "aws_s3_bucket_acl" "this" {
  bucket = join("", aws_s3_bucket.this.*.id)
  acl    = var.acl
}
resource "aws_s3_bucket_public_access_block" "this" {
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  bucket                  = join("", aws_s3_bucket.this.*.id)
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.id)
  policy = var.policy
}
