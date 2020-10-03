variable "AWS_REGION" {
  default = "us-east-1"
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

variable "ENVIRONMENT" {
  type = string
  default="master"
}

variable "BUCKET" {
  type = string
}