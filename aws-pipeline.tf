module codepipeline-stack {
    source        = "./Modules/pipeline/"
    GITHUB_REPO   = "project-stack"
    ENVIRONMENT   = "${terraform.workspace}"
    TYPE          = "stack"
    PROVIDER      = "GitHub"
    GITHUB_OWNER  = var.GITHUB_OWNER
    GITHUB_TOKEN  = var.GITHUB_TOKEN
    GITHUB_BRANCH = var.GITHUB_BRANCH
}

module codepipeline-app {
    source        = "./Modules/pipeline/"
    GITHUB_REPO   = "project-app"
    ENVIRONMENT   = "${terraform.workspace}"
    TYPE          = "app"
    PROVIDER      = "GitHub"
    GITHUB_OWNER  = var.GITHUB_OWNER
    GITHUB_TOKEN  = var.GITHUB_TOKEN
    GITHUB_BRANCH = var.GITHUB_BRANCH
}