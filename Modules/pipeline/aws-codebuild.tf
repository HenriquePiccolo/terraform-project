resource "aws_codebuild_project" "codebuild" {
    name          = "codebuild-${var.TYPE}-${var.GITHUB_BRANCH}"
    description   = "Codebuild ${var.TYPE} ${var.GITHUB_BRANCH}"
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
            value = var.GITHUB_REPO
        }
        
        environment_variable{
            name = "ECR_ADDRESS"
            value = aws_ecr_repository.ecr.repository_url
        }

        environment_variable{
            name = "STAGE"
            value = var.ENVIRONMENT
        }

        environment_variable{
            name = "BUCKET_NAME"
            value = aws_s3_bucket.terraform_state_s3.id
        }
    }

    
    source {
        type        = "CODEPIPELINE"
        buildspec   = data.template_file.buildspec-codebuild.rendered
    }

    tags = {
        Environment = var.ENVIRONMENT
    }
}