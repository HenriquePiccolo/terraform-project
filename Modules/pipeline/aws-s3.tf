resource "aws_s3_bucket" "terraform_state_s3" {
    bucket        = "${var.GITHUB_REPO}-${var.ENVIRONMENT}"
    acl           = "private"
    force_destroy = true
}