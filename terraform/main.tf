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

# VPC y Subnets (usa las default)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "sura_api" {
  name        = "sura-api-sg"
  description = "Security group para SURA API"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sura-api-sg"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "sura" {
  name = "sura-cluster"

  tags = {
    Name        = "SURA Cluster"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "sura_api" {
  name              = "/ecs/sura-api"
  retention_in_days = 7

  tags = {
    Name = "sura-api-logs"
  }
}

# Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "sura-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Definition
resource "aws_ecs_task_definition" "sura_api" {
  family                   = "sura-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # 1 vCPU
  memory                   = "2048" # 2 GB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "sura-api"
      image     = "${var.docker_image}:${var.docker_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "ASPNETCORE_ENVIRONMENT"
          value = "Production"
        },
        {
          name  = "ASPNETCORE_URLS"
          value = "http://+:8080"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.sura_api.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = {
    Name        = "sura-api-task"
    Environment = "Production"
  }
}

# ECS Service
resource "aws_ecs_service" "sura_api" {
  name            = "sura-api-service"
  cluster         = aws_ecs_cluster.sura.id
  task_definition = aws_ecs_task_definition.sura_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.sura_api.id]
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 60

  tags = {
    Name        = "sura-api-service"
    Environment = "Production"
  }
}

# Outputs
output "cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.sura.name
}

output "service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.sura_api.name
}

output "task_definition" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.sura_api.arn
}

output "log_group" {
  description = "CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.sura_api.name
}