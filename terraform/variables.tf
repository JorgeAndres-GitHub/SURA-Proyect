variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Imagen de Docker desde DockerHub"
  type        = string
}

variable "docker_tag" {
  description = "Tag de la imagen Docker"
  type        = string
  default     = "latest"
}