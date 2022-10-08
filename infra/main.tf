module "ecs" {
  source                   = "./modules/ecs"
  project_name             = var.project_name
  ecr_repository_name      = var.ecr_repository_name
  vpc_id                   = var.vpc_id
  ecs_execution_role_arn   = module.iam_ecs.ecs_execution_role_arn
  ecs_tasks_container_role = module.iam_ecs.ecs_tasks_container_role
  s3_bucket_name           = var.s3_bucket_name
  image_hash               = var.image_hash
}
