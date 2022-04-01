variable "project_name" {}
variable "ecr_repository_url" {}
variable "ecs_execution_role_arn" {}

variable "image_tag" {
  type    = string
  default = "aws-fastapi-image"
}

variable "fargate_cpu" {
  type        = number
  default     = 256
  description = "1vCPU = 1024"
}

variable "fargate_memory" {
  type    = number
  default = 512
}
