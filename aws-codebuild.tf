#resource "aws_codebuild_project" "codebuild-app" {
#    name            = "codebuild-docker"
#    description     = "Codebuilt dockerfile app"
#    build_timeout   = "25"
#    service_role    = aws_iam_role.codebuild-role.arn
#
#    artifacts {
#        type = "CODEPIPELINE"
#    }
#
#    environment {
#        compute_type = "BUILD_GENERAL1_SMALL"
#        image        = "aws/codebuild/standard:1.0"
#        type         = "LINUX_CONTAINER"
#        image_pull_credentials_type = "CODEBUILD"
#
#    }
#
#    source {
#        type = "CODEPIPELINE"
#        buildspec   = data.template_file.buildspec-docker.rendered
#    }
#}