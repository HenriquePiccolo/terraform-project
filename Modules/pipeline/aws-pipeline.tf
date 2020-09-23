resource  "aws_codepipeline" "codepipeline" {
    name     = "${var.GITHUB_REPO}-${var.GITHUB_BRANCH}"
    role_arn = aws_iam_role.codepipeline-role.arn
    

    artifact_store {
        location = aws_s3_bucket.terraform_state_s3.bucket
        type     = "S3"
    }

    stage {
        name   = "Source"
        action {
            name             = "Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = var.PROVIDER
            version          = "1"
            run_order        = 1
            output_artifacts = ["source_output"]

            configuration    = {
                Owner                = var.GITHUB_OWNER
                Repo                 = var.GITHUB_REPO
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
                ProjectName  = "codebuild-${var.TYPE}-${var.GITHUB_BRANCH}"
            }
        }
    }
}