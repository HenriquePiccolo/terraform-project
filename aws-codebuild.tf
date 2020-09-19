resource "aws_codebuild_project" "codebuild-docker" {
    name            = "codebuild-docker-${terraform.workspace}"
    description     = "Codebuilt dockerfile docker"
    build_timeout   = "25"
    service_role    = aws_iam_role.codebuild-role.arn

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
            value = var.project_name
        }
        
        environment_variable{
            name = "ECR_ADDRESS"
            value = aws_ecr_repository.ecr.repository_url
        }
    }

    
    source {
        type        = "CODEPIPELINE"
        buildspec   = data.template_file.buildspec-docker.rendered
    }

    tags = {
        Environment = var.environment
    }
}

resource "aws_codebuild_project" "codebuild-stack" {
    name          = "codebuild-stack-${terraform.workspace}"
    description   = "Codebuilt stack"
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
            value = var.project_name
        }
        
        environment_variable{
            name = "ECR_ADDRESS"
            value = aws_ecr_repository.ecr.repository_url
        }

        environment_variable{
            name = "STAGE"
            value = var.environment
        }

        environment_variable{
            name = "BUCKET_NAME"
            value = aws_s3_bucket.bucket_stack.id
        }
    }

    
    source {
        type        = "CODEPIPELINE"
        buildspec   = data.template_file.buildspec-stack.rendered
    }

    tags = {
        Environment = var.environment
    }
}