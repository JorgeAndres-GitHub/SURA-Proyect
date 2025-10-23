terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
}

# =============================
# SECURITY GROUP (puerto 8080)
# =============================
resource "aws_security_group" "sura_sg" {
  name        = "sura-api-sg"
  description = "Permitir acceso HTTP a la API"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "API HTTP"
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

# =============================
# VPC DEFAULT
# =============================
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# =============================
# EC2 INSTANCE
# =============================
resource "aws_instance" "sura_api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # puedes subir a t3.small si necesitas más RAM
  subnet_id     = element(data.aws_subnet_ids.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.sura_sg.id]
  associate_public_ip_address = true
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              docker pull ${var.docker_image}:${var.docker_tag}
              docker run -d -p 8080:8080 \
                -e ASPNETCORE_URLS=http://+:8080 \
                -e ASPNETCORE_ENVIRONMENT=Production \
                ${var.docker_image}:${var.docker_tag}
              EOF

  tags = {
    Name = "sura-api-ec2"
  }
}

# =============================
# OBTENER AMI DE UBUNTU
# =============================
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# =============================
# OUTPUTS
# =============================
output "instance_public_ip" {
  value = aws_instance.sura_api.public_ip
}

output "api_url" {
  value = "http://${aws_instance.sura_api.public_ip}:8080"
}
