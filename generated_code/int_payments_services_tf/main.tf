module "applications" {
  source = "../modules/apps"

  services           = var.services
  base_config        = var.base_config
  cloudwatch_actions = var.cloudwatch_actions

  alb         = data.terraform_remote_state.silo_state.outputs.alb
  cluster_arn = data.terraform_remote_state.silo_state.outputs.cluster_arn
  api_id      = data.terraform_remote_state.silo_state.outputs.api_id
  vpc_link_id = data.terraform_remote_state.silo_state.outputs.vpc_link_id

  is_dr = var.is_dr

  rds_snapshot_names = var.rds_snapshot_names

  ecs_migration = var.ecs_migration
}