locals {
    buildspec-codebuild    = "${path.module}/data/buildspec-${var.TYPE}.tpl"
}

data "template_file" "buildspec-codebuild" {
    template = file(local.buildspec-codebuild)
    vars     = {}
}