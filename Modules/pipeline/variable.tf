variable "AWS_REGION" {
  default = "us-east-1"
}

variable "REPOSITORY"{
  type = string
}

variable "ENVIRONMENT" {
  type = string
}

variable "TYPE" {
  type = string
}

variable "PROVIDER" {
  type = string
}

variable "OWNER" {
  type = string
}

variable "GITHUB_TOKEN" {
  type = string
}