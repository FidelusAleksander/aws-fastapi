variable "project_name" {}
variable "ecs_execution_role_arn" {}
variable "ecs_tasks_container_role" {}
variable "ecr_repository_name" {}
variable "image_tag" {}
variable "vpc_id" {}
variable "s3_bucket_name" {}

variable "fargate_cpu" {
  type        = number
  default     = 256
  description = "1vCPU = 1024"
}

variable "fargate_memory" {
  type    = number
  default = 512
}
