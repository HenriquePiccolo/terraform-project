resource "aws_lambda_function" "lambda-api-pipeline" {
    filename      = "${path.module}/data/handler-${var.environment}.zip"
    function_name = "lambda-caller-pipeline"
    role          = aws_iam_role.lambda-role.arn
    runtime       = "python3.6"
    handler       = "handler.main"

}