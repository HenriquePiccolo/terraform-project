resource "aws_codepipeline" "codepipeline" {
    name     = "project-app-${terraform.workspace}"
    role_arn = aws_iam_role.codepipeline-role.arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type     = "S3"

        #encryption_key {
        #    id   = data.aws_kms_alias.s3mskey.arn
        #    type = "KMS"
        #}
    }

    stage {
        name        = "Source"
        action {
            name        = "Source"
            category    = "Source"
            owner       = "ThirdParty"
            provider    = "GitHub"
            version     = 1
            run_order   = 1
            output_artifacts = ["code"]

            configuration = {
                Repo            = "project-app"
                Owner           = "HenriquePiccolo"
                Branch          = "master"
                OAuthToken      = var.github_token
            }
        }
    }

    stage {
        name = "Continuos-Integration"

        action {
            name            = "Build-Test"
            run_order       = 1
            category        = "Build"
            owner           = "AWS"
            provider        = "CodeBuild"
            version         = 1
            input_artifacts = ["code"]
            output_artifacts = ["task"]
            configuration   = {
                ProjectName = "codebuild-app"
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