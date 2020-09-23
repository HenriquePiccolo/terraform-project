resource "aws_ecr_repository" "ecr" {
    name = "${var.GITHUB_REPO}-${var.GITHUB_BRANCH}"
    image_scanning_configuration {
        scan_on_push = false
    }
}

resource "aws_ecr_repository_policy" "ecr-repository-policy" {
    repository = "${var.GITHUB_REPO}-${var.GITHUB_BRANCH}"
    policy     = data.aws_iam_policy_document.data-ecr-policy.json
    depends_on = [aws_ecr_repository.ecr]
}