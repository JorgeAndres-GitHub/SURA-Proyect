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

# 1️⃣ Obtener la VPC y subred por defecto
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2️⃣ Crear grupo de seguridad que permita HTTP (8080) y SSH (22)
resource "aws_security_group" "sura_sg" {
  name        = "sura-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3️⃣ Crear par de llaves SSH
resource "aws_key_pair" "sura_key" {
  key_name   = "sura-key"
  public_key = var.ssh_public_key
}

# 4️⃣ Crear instancia EC2 y ejecutar el contenedor
resource "aws_instance" "sura_ec2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.sura_sg.id]
  key_name      = aws_key_pair.sura_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker run -d -p 8080:8080 ${var.docker_image}:${var.docker_tag}
              EOF

  tags = {
    Name = "SURA EC2"
  }
}

# 5️⃣ Mostrar la IP pública
output "instance_public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.sura_ec2.public_ip
}

output "api_url" {
  description = "URL de acceso público a la API"
  value       = "http://${aws_instance.sura_ec2.public_ip}:8080"
}
