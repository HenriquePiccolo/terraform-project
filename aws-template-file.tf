locals {
    buildspec-docker    = "${path.module}/data/buildspec-docker.tpl"
    buildspec-stack     = "${path.module}/data/buildspec-stack.tpl"
}

data "template_file" "buildspec-docker" {
    template = file(local.buildspec-docker)
    vars     = {}
}

data "template_file" "buildspec-stack" {
    template = file(local.buildspec-stack)
    vars     = {}
}