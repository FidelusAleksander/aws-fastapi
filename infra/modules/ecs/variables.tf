variable "project_name" {}
variable "ecs_execution_role_arn" {}
variable "ecr_repository_name" {}
variable "vpc_id" {}

variable "fargate_cpu" {
  type        = number
  default     = 256
  description = "1vCPU = 1024"
}

variable "fargate_memory" {
  type    = number
  default = 512
}
