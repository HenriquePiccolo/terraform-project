data "aws_iam_policy_document" "data-ecr-policy"{
    version = "2012-10-17"
    statement {
        effect  = "Allow"
        actions = ["ecr:*"]
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "codepipeline-role-document"{
    version   = "2012-10-17"
    statement {
        effect     = "Allow"
        actions    = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["codepipeline.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "codebuild-role-document"{
    version   = "2012-10-17"
    statement {
        effect     = "Allow"
        actions    = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["codebuild.amazonaws.com"]
        }
    }
}


data "aws_iam_policy_document" "codepipeline-policy-document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = ["s3:*"]
        resources = [
            "${aws_s3_bucket.terraform_state_s3.arn}",
            "${aws_s3_bucket.terraform_state_s3.arn}/*"
        ]
    }
    statement {
        effect = "Allow"
        actions = [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "ecr:*",
        ]
        resources = [
            "*",
        ]
    }
}

data "aws_iam_policy_document" "codebuild-policy-document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = [
            "*",
        ]
    }
    statement {
        effect = "Allow"
        actions = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs",
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "ec2:CreateNetworkInterfacePermission",
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "s3:*",
        ]
        resources = [
            "${aws_s3_bucket.terraform_state_s3.arn}",
            "${aws_s3_bucket.terraform_state_s3.arn}/*"
        ]
    }
    statement {
        effect = "Allow"
        actions = [
            "ecr:*",
        ]
        resources = [
            "*",
        ]
    }
}

resource "aws_iam_role" "codepipeline-role" {
    name               = "${var.GITHUB_REPO}-${var.ENVIRONMENT}-codepipeline-role"
    assume_role_policy = data.aws_iam_policy_document.codepipeline-role-document.json
}

resource "aws_iam_role_policy" "codepipeline-policy" {
    name    = "codepipeline-policy"
    role    = aws_iam_role.codepipeline-role.id
    policy  = data.aws_iam_policy_document.codepipeline-policy-document.json
}

resource "aws_iam_role" "codebuild-role" {
    name               = "${var.GITHUB_REPO}-${var.ENVIRONMENT}-codebuild-role"
    assume_role_policy = data.aws_iam_policy_document.codebuild-role-document.json
}

resource "aws_iam_role_policy" "codebuild-policy" {
    name    = "codebuild-policy"
    role    = aws_iam_role.codebuild-role.id
    policy  = data.aws_iam_policy_document.codebuild-policy-document.json
}

data "aws_iam_policy_document" "lambda-role-document"{
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
  name               = "lambda-role-${var.GITHUB_REPO}-${var.ENVIRONMENT}"
  assume_role_policy = data.aws_iam_policy_document.lambda-role-document.json
}