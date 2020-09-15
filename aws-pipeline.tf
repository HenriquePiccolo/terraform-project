resource "aws_codepipeline" "codepipeline" {
    name     = "project-app-${terraform.workspace}"
    role_arn = aws_iam_role.codepipeline-role.arn
    

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type     = "S3"
    }

    stage {
        name   = "Source"
        action {
            name        = "Source"
            category    = "Source"
            owner       = "ThirdParty"
            provider    = "GitHub"
            version     = "1"
            run_order   = 1
            output_artifacts = ["source_output"]

            configuration = {
                Owner                = var.owner_repo
                Repo                 = var.name_repo
                Branch               = "${terraform.workspace}"
                OAuthToken           = var.github_token
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
                ProjectName  = "codebuild-docker"
            }
        }
    }
}