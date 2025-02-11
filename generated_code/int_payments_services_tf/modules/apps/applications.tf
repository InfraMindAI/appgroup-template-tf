module "payment_analysis" {
  source = "./payment-analysis"

  task                           = merge(local._task, local.payment_analysis_service["task"])
  service                        = merge(local._service, local.payment_analysis_service["service"])
  cluster                        = local.cluster
  autoscaling                    = local.payment_analysis_service["autoscaling"]
  ecs_migration                  = var.ecs_migration
  base_config                    = var.base_config
  lb                             = local.lb
  logging                        = local.base_logging_config
  actions                        = local.sns_actions
  cloudwatch                     = local.cloudwatch
  use_account_alias              = var.is_dr
  global_secret_policies         = local.global_secret_policies
  r53_global_dns_account_zone_id = local.r53_global_dns_account_zone_id
  secrets_recovery_window_days   = local.secrets_recovery_window_days
  vpn_cidr_blocks                = local.vpn_cidr_blocks
  alert_actions                  = local.communications_alert_actions

  rds                      = local.payment_analysis_service["rds"]
  _rds_params              = local._rds_params
  _rds_audit_config        = local._rds_audit_config
  rds_snapshot_name        = var.rds_snapshot_names["payment_analysis"]
  rds_security_group_rules = local.rds_security_group_rules

  es           = local.payment_analysis_service["es"]
  es_dns_entry = local._es_dns_entry

  api_id      = var.api_id
  vpc_link_id = var.vpc_link_id

  ec                      = local.payment_analysis_service["ec"]
  ec_security_group_rules = local.ec_security_group_rules
  ec_route53              = local.ec_route53
  global_dns              = local.global_dns_defaults
}