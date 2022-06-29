resource "aws_s3_bucket" "smrdev" {
  bucket = "pimcore-mms-dev"

  tags = {
    Name        = "pimcore-mms-dev"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "smrdet_acl" {
  bucket = aws_s3_bucket.smrdev.id
  acl    = "private"
}