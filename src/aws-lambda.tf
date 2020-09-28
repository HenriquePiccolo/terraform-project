data "aws_iam_policy_document" "lambda-policy-document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = [
            "codepipeline:*",
        ]
        resources = [
            "arn:aws:codepipeline:us-east-1:${var.ACCOUNT}:project-stack-${terraform.workspace}"
        ]
    }
}

data "aws_iam_policy_document" "lambda-role-document" {
    version   = "2012-10-17"
    statement {
        effect     = "Allow"
        actions    = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
   }
}

resource "aws_iam_role" "lambda-role" {
    name               = "lambda-role-${terraform.workspace}"
    assume_role_policy = data.aws_iam_policy_document.lambda-role-document.json
}

resource "aws_iam_role_policy" "lambda-policy" {
    name   = "lambda-policy-${terraform.workspace}"
    role   = aws_iam_role.lambda-role.id
    policy = data.aws_iam_policy_document.lambda-policy-document.json
}

resource "aws_lambda_function" "lambda-api-pipeline" {
    filename      = "${path.module}/data/handler-${terraform.workspace}.zip"
    function_name = "lambda-caller-pipeline-${terraform.workspace}"
    role          = aws_iam_role.lambda-role.arn
    runtime       = "python3.8"
    handler       = "handler.main"

}