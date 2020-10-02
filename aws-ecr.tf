data "aws_iam_policy_document" "data-ecr-policy"{
    version = "2012-10-17"
    statement {
        effect  = "Allow"
        actions = ["ecr:*"]
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
    }
}

resource "aws_ecr_repository" "ecr" {
    name = "hackaton-app-${var.ENVIRONMENT}"
    image_scanning_configuration {
        scan_on_push = false
    }
}

resource "aws_ecr_repository_policy" "ecr-repository-policy" {
    repository = "hackaton-app-${var.ENVIRONMENT}"
    policy     = data.aws_iam_policy_document.data-ecr-policy.json
    depends_on = [aws_ecr_repository.ecr]
}