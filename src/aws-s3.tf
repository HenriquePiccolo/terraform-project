resource "aws_s3_bucket" "s3-codepipeline-app" {
    bucket        = "${var.BUCKET}-${var.ENVIRONMENT}-tfstate"
    acl           = "private"
    force_destroy = true
}
