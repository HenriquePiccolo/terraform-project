resource "aws_codebuild_project" "codebuild-docker" {
    name            = "codebuild-docker"
    description     = "Codebuilt dockerfile docker"
    build_timeout   = "25"
    service_role    = aws_iam_role.codebuild-role.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true

        environment_variable {
            name = "PROJECT_NAME"
            value = var.project_name
        }
        
        environment_variable{
            name = "REPOSITORY_URI"
            value = aws_ecr_repository.ecr.repository_url
        }
    }

    
    source {
        type        = "CODEPIPELINE"
        buildspec   = data.template_file.buildspec-docker.rendered
    }

    tags = {
        Environment = "${terraform.workspace}"
    }
}