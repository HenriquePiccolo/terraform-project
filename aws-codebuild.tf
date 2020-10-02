locals {
    buildspec-app    = "${path.module}/data/buildspec-app.tpl"
}

data "template_file" "buildspec-app" {
    template = file(local.buildspec-app)
    vars     = {}
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
            "${aws_s3_bucket.s3-codepipeline-app.arn}",
            "${aws_s3_bucket.s3-codepipeline-app.arn}/*"
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

resource "aws_iam_role" "codebuild-role" {
    name               = "codebuild-role"
    assume_role_policy = data.aws_iam_policy_document.codebuild-role-document.json
}

resource "aws_iam_role_policy" "codebuild-policy" {
    name    = "codebuild-policy"
    role    = aws_iam_role.codebuild-role.id
    policy  = data.aws_iam_policy_document.codebuild-policy-document.json
}

resource "aws_codebuild_project" "codebuild" {
    name          = "hackaton-app"
    description   = "Codebuild hackaton-app"
    build_timeout = "25"
    service_role  = aws_iam_role.codebuild-role.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type    = "BUILD_GENERAL1_SMALL"
        image           = "aws/codebuild/standard:4.0"
        type            = "LINUX_CONTAINER"
        privileged_mode = true

        environment_variable {
            name = "PROJECT_NAME"
            value = "Hackaton-project-app"
        }
        
        environment_variable{
            name = "ECR_ADDRESS"
            value = aws_ecr_repository.ecr.repository_url
        }
    }
    
    source {
        type        = "CODEPIPELINE"
        buildspec   = data.template_file.buildspec-app.rendered
    }
}