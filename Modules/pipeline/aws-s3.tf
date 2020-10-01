resource "aws_s3_bucket" "terraform_state_s3" {
    bucket        = "${var.GITHUB_REPO}-${var.ENVIRONMENT}"
    acl           = "private"
    force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.terraform_state_s3.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}