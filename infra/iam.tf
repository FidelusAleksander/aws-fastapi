module "iam_ecs" {
  source       = "./modules/iam/ecs"
  project_name = var.project_name
}

module "iam_s3_for_ecs" {
  source  = "./modules/iam/s3"
  role_id = module.iam_ecs.ecs_tasks_container_role_id
}

module "iam_ecr_for_ecs" {
  source              = "./modules/iam/ecr"
  role_id             = module.iam_ecs.ecs_execution_role_id
  ecr_repository_name = var.ecr_repository_name
}

module "iam_logs_for_ecs" {
  source  = "./modules/iam/logs"
  role_id = module.iam_ecs.ecs_execution_role_id
}
