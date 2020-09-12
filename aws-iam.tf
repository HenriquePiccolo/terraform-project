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

resource "aws_iam_role" "codepipeline-role"{
    name               = "codepipeline-role"
    assume_role_policy = data.aws_iam_policy_document.codepipeline-role-document.json
}