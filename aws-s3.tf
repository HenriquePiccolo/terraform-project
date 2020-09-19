resource "aws_s3_bucket" "bucket_app" {
    bucket        = "project-app-bucket-${terraform.workspace}"
    acl           = "private"
    force_destroy = true
}

resource "aws_s3_bucket" "bucket_stack" {
    bucket        = "project-stack-bucket-rm335842"
    acl           = "private"
    force_destroy = true
}