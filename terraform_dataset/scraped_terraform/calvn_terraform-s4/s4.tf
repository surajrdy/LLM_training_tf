provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_s3_bucket" "b" {
    bucket = "${var.bucket_name}"
    acl = "private"

    versioning {
      enabled = true
    }

    tags {
      Environment = "${var.environment}"
    }
}
