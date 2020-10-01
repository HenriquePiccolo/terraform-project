resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.terraform_state_s3.arn
}

resource "aws_lambda_function" "func" {
  filename      = "${path.module}/data/handler-slack.zip"
  function_name = "lambda-to-slack-${var.GITHUB_REPO}-${var.ENVIRONMENT}"
  role          = aws_iam_role.lambda-role.arn
  handler       = "handler.hello"
  runtime       = "python3.8"
}