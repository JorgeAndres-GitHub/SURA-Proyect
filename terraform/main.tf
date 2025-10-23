terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_apprunner_service" "sura_api" {
  service_name = "sura-api"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"
        runtime_environment_variables = {
          ASPNETCORE_ENVIRONMENT = "Production"
          ASPNETCORE_URLS        = "http://+:8080"
        }
      }
      image_identifier      = "${var.docker_image}:${var.docker_tag}"
      image_repository_type = "ECR_PUBLIC"
    }
    
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu    = "1 vCPU"
    memory = "2 GB"
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }

  tags = {
    Name        = "SURA API"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

output "service_url" {
  description = "URL del servicio App Runner"
  value       = aws_apprunner_service.sura_api.service_url
}

output "service_arn" {
  description = "ARN del servicio"
  value       = aws_apprunner_service.sura_api.arn
}

output "service_status" {
  description = "Estado del servicio"
  value       = aws_apprunner_service.sura_api.status
}