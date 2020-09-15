variable "aws_region" {
    description = "The AWS region to create things in."
    default     = "us-east-1"
}

variable "github_token" {
    type = string
}

variable "name_repo" {
    type    = string
    default = "project-app"
}

variable "owner_repo" {
    type    = string
    default = "HenriquePiccolo"
}

variable "project_name"{
    type    = string
    default = "project-app"
}