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

variable "name_repo_stack" {
    type    = string
    default = "project-stack"
}

variable "owner_repo" {
    type    = string
    default = "HenriquePiccolo"
}

variable "ecr_name"{
    type    = string
    default = "hackathon-app"
}

variable "project_name"{
    type    = string
    default = "hackathon-app"
}

variable "environment" {
    type    = string
}