resource "aws_ecr_repository" "ecr" {
    name = "${var.ecr_name}-${terraform.workspace}"
    image_scanning_configuration {
        scan_on_push = false
    }
}

resource "aws_ecr_repository_policy" "ecr-repository-policy" {
    repository = "${var.ecr_name}-${terraform.workspace}"
    policy     = data.aws_iam_policy_document.data-ecr-policy.json
    depends_on = [aws_ecr_repository.ecr]
}