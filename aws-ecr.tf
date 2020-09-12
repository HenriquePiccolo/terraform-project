resource "aws_ecr_repository" "ecr" {
    name = "project-app-${terraform.workspace}"
    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository_policy" "ecr-repository-policy" {
    repository = "project-app-${terraform.workspace}"
    policy     = data.aws_iam_policy_document.data-ecr-policy.json
    depends_on = [aws_ecr_repository.ecr]
}