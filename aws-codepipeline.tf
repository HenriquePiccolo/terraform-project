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

data "aws_iam_policy_document" "codepipeline-policy-document" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = ["s3:*"]
        resources = [
            "${aws_s3_bucket.s3-codepipeline-app.arn}",
            "${aws_s3_bucket.s3-codepipeline-app.arn}/*"
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


resource "aws_iam_role" "codepipeline-role" {
    name               = "codepipeline-role-${var.ENVIRONMENT}"
    assume_role_policy = data.aws_iam_policy_document.codepipeline-role-document.json
}

resource "aws_iam_role_policy" "codepipeline-policy" {
    name    = "codepipeline-policy-${var.ENVIRONMENT}"
    role    = aws_iam_role.codepipeline-role.id
    policy  = data.aws_iam_policy_document.codepipeline-policy-document.json
}


resource  "aws_codepipeline" "codepipeline" {
    name     = "hackathon-CI-app-${var.ENVIRONMENT}"
    role_arn = aws_iam_role.codepipeline-role.arn
    

    artifact_store {
        location = aws_s3_bucket.s3-codepipeline-app.bucket
        type     = "S3"
    }

    stage {
        name   = "Source"
        action {
            name             = "Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            run_order        = 1
            output_artifacts = ["source_output"]

            configuration    = {
                Owner                = var.GITHUB_OWNER
                Repo                 = "Hackaton-project-app"
                Branch               = var.GITHUB_BRANCH
                OAuthToken           = var.GITHUB_TOKEN
                PollForSourceChanges = true
            }
        }
    }

    stage {
        name   = "Build"
        action {
            name             = "Build"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["build_output"]
            version          = "1"
            configuration    = {
                ProjectName  = "hackaton-app"
            }
        }
    }
}

resource "aws_codepipeline_webhook" "bar" {
  name            = "test-webhook-github-bar"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = var.GITHUB_TOKEN
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}