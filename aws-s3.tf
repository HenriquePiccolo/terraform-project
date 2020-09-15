resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = var.bucket_name
    acl    = "private"
}