variable "AWS_REGION" {
    description = "The AWS region to create things in."
    default     = "us-east-1"
}

variable "ACCOUNT" {
    type    = string
    default = "123456"
}

variable "GITHUB_OWNER" {
    type    = string
    default = "123456"
}

variable "GITHUB_TOKEN" {
    type    = string
    default = "123456"
}

variable "GITHUB_BRANCH" {
    type    = string
    default = "main"
}