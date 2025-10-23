variable "aws_region" {
  description = "Región de AWS"
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

variable "key_name" {
  description = "Nombre del par de claves SSH para EC2"
  type        = string
}
