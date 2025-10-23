variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Imagen Docker desde DockerHub"
  type        = string
}

variable "docker_tag" {
  description = "Tag de la imagen Docker"
  type        = string
  default     = "latest"
}

variable "ami_id" {
  description = "AMI de Ubuntu (por defecto us-east-1)"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04
}

variable "ssh_public_key" {
  description = "Clave pública SSH para acceder al EC2"
  type        = string
}
