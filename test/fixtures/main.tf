terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

locals {
  greeting = "Hello from environment: ${var.environment}"
}

resource "local_file" "hello" {
  content  = local.greeting
  filename = "${path.module}/hello.txt"
}

output "message" {
  value = local.greeting
}
