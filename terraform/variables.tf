variable "aws_region" {
  description = "Región de AWS"
  type        = string
}

variable "dockerhub_username" {
  description = "Usuario de DockerHub"
  type        = string
}

variable "dockerhub_token" {
  description = "Token de acceso de DockerHub"
  type        = string
}

variable "docker_image" {
  description = "Nombre de la imagen en DockerHub (sin tag)"
  type        = string
}

variable "docker_tag" {
  description = "Tag de la imagen de Docker"
  type        = string
  default     = "latest"
}
