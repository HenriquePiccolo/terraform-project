variable "AWS_REGION" {
    description = "The AWS region to create things in."
    default     = "us-east-1"
}

variable "ACCOUNT" {
    type    = string
}

variable "GITHUB_OWNER" {
    type = string
}

variable "GITHUB_TOKEN" {
    type = string
}

variable "GITHUB_BRANCH" {
    type = string
}