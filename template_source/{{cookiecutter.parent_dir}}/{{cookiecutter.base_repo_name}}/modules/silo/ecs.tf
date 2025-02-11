module "ecs_cluster" {
  source = "../../.modules_tf/ecs-cluster-4.0.0//modules/v0.12/ecs-cluster"

  env              = local.env
  base_config      = var.base_config
  stack_name       = local.stack_name
  stack_name_short = local.stack_name

  vpc_id          = local.vpc_id
  vpc_subnet_ids  = local.subnet_ids
  vpn_cidr_blocks = local.vpn_cidr_blocks
  actions         = local.sns_actions
  cloudwatch      = local.cloudwatch

  resource_tags = module.silo_tags.tags

  enable_container_insights = local.env_type == "prod" ? "true" : "false"

  lb_config = {
    access_logs_enabled = local.env_type != "dev" ? "true" : "false"
  }

  is_dr = var.is_dr
}