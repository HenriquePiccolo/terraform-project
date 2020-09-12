#data "aws_kms_alias" "s3kmskey" {
#    name = "alias/
#}
resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = "project-app-bucket-${terraform.workspace}"
    acl    = "private"
}

