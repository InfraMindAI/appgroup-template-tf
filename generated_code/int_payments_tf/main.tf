module "silo" {
  source = "../modules/silo"

  is_dr              = var.is_dr
  base_config        = var.base_config
  cloudwatch_actions = var.cloudwatch_actions

  rds               = var.rds
  rds_snapshot_name = var.rds_snapshot_name

  ec = var.ec
}