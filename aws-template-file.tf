locals {
    buildspec-docker = "${path.module}/data/buildspec-docker.tpl"
}

#data "template_file" "buildspec-docker" {
#    template = file(local.buildspec-docker)
#    vars     = {
#    }
#}