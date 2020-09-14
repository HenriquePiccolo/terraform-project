resource "aws_codepipeline" "codepipeline" {
    name     = "project-app-${terraform.workspace}"
    role_arn = aws_iam_role.codepipeline-role.arn
    

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type     = "S3"

        encryption_key {
            id   = aws_kms_alias.s3kmskey.arn
            type = "KMS"
        }
    }

    stage {
        name        = "Source"
        action {
            name        = "Source"
            category    = "Source"
            owner       = "ThirdParty"
            provider    = "GitHub"
            version     = "1"
            run_order   = 1
            output_artifacts = ["source_output"]

            configuration = {
                Owner           = var.owner_repo
                Repo            = var.name_repo
                Branch          = "${terraform.workspace}"
                OAuthToken      = var.github_token
                PollForSourceChanges = true
            }
        }
    }

    stage {
        name = "Build"
        action {
            name             = "Build"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["build_output"]
            version          = "1"
            configuration    = {
                ProjectName          = "codebuild-app"
                EnvironmentVariables = jsonencode([
                    {
                        name  = "PROJECT_NAME"
                        type  = "PLAINTEXT"
                        value = "project-app"
                    },
                    {
                        name  = "ECR_ADDRESS"
                        type  = "PLAINTEXT"
                        value = "project-app"
                    },
                ])
            }
        }
    }
}