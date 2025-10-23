provider "aws" {
  region = "ap-southeast-2"
}

data "aws_s3_bucket" "bucket" {
  bucket = "20240906"
}

output "bucket_details" {
  value = {
    name                      = data.aws_s3_bucket.bucket.id
    region                    = data.aws_s3_bucket.bucket.region
    arn                       = data.aws_s3_bucket.bucket.arn
    bucket_domain_name        = data.aws_s3_bucket.bucket.bucket_domain_name
    bucket_regional_domain_name = data.aws_s3_bucket.bucket.bucket_regional_domain_name
  }
}
