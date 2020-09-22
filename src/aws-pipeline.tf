module codepipeline-stack {
    source       = "../Modules/pipeline/"
    REPOSITORY   = "project-stack"
    ENVIRONMENT  = "${terraform.workspace}"
    TYPE         = "stack"
    PROVIDER     = "GitHub"
    OWNER        = var.GITHUB_OWNER
    GITHUB_TOKEN = var.GITHUB_TOKEN
}

module codepipeline-app {
    source       = "../Modules/pipeline/"
    REPOSITORY   = "project-app"
    ENVIRONMENT  = "${terraform.workspace}"
    TYPE         = "app"
    PROVIDER     = "GitHub"
    OWNER        = var.GITHUB_OWNER
    GITHUB_TOKEN = var.GITHUB_TOKEN
}