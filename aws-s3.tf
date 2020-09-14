resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = "project-app-bucket-${terraform.workspace}"
    acl    = "private"
}