data "aws_iam_policy_document" "codepipeline-role-document"{
    version   = "2012-10-17"
    statement {
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
        actions    = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["codebuild.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "data-ecr-policy"{
    version = "2012-10-17"
    statement {
        actions = ["ecr:*"]
        sid     = "AllowAll"
        effect  = "Allow"
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
    }
}

data "aws_iam_policy_document" "codepipeline-policy-document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = [
            "s3:*",
        ]
        resources = [
            "${aws_s3_bucket.codepipeline_bucket.arn}",
            "${aws_s3_bucket.codepipeline_bucket.arn}/*",
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
}

resource "aws_iam_role" "codepipeline-role" {
    name               = "codepipeline-role"
    assume_role_policy = data.aws_iam_policy_document.codepipeline-role-document.json
}

resource "aws_iam_role_policy" "codepipeline-policy" {
    name    = "codepipeline-policy"
    role    = aws_iam_role.codepipeline-role.id
    policy  = data.aws_iam_policy_document.codepipeline-policy-document.json
}

resource "aws_iam_role" "codebuild-role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild-role-document.json
}