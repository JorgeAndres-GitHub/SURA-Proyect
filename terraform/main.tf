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

# VPC y subred predeterminadas
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  default_for_az = true
}

# Security group para permitir tráfico HTTP (puerto 8080)
resource "aws_security_group" "sura_sg" {
  name        = "sura-ec2-sg"
  description = "Permite tráfico HTTP para la API"
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
    Name = "sura-ec2-sg"
  }
}

# Instancia EC2
resource "aws_instance" "sura_ec2" {
  ami                         = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.sura_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker

              docker login -u ${var.dockerhub_username} -p ${var.dockerhub_token}
              docker pull ${var.docker_image}:${var.docker_tag}
              docker run -d -p 8080:8080 ${var.docker_image}:${var.docker_tag}
              EOF

  tags = {
    Name = "sura-ec2-instance"
  }
}

output "public_ip" {
  description = "Dirección IP pública de la instancia"
  value       = aws_instance.sura_ec2.public_ip
}
