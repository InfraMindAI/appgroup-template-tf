module "rds" {
  source = "../../.modules_tf/rds-cluster-7.0.2//modules/v0.12/rds-cluster"

  id = local.name

  base_config   = var.base_config
  resource_tags = module.silo_tags.tags

  vpc_id               = local.vpc_id
  subnets              = local.subnet_ids
  r53_zone_id          = local.r53_company_internal_zone_id
  security_group_rules = local.rds_security_group_rules

  cluster                    = local.rds_cluster
  instances                  = var.rds["instances"]
  cluster_param_group_params = local.rds_params

  cloudwatch                  = local.cloudwatch
  sns_actions                 = local.sns_actions
  audit_config                = local.rds_audit_config
  cluster_alarms              = var.rds["alarms"]
  cluster_alerts              = var.rds["alerts"]
  slow_query_log_metric_alarm = var.rds["slow_query"]

  dr_account = var.is_dr

  restore_from_snapshot = {
    snapshot_identifier = var.rds_snapshot_name
  }
}

module "rds_dns" {
  source = "../../.modules_tf/rds-cluster-7.0.2//modules/v0.12/rds-cluster/rds-cluster-dns"

  id                    = local.name
  rds_cluster_endpoints = module.rds.cluster_endpoints

  cluster = merge(local.rds_cluster, {
    create_cluster_reader_dns      = "true"
    r53_global_internal_id         = local.r53_global_dns_account_zone_id
    dns_account_r53_hosted_zone_id = local.r53_global_dns_account_zone_id
  })
}

module "rds_audit_params" {
  source = "../../.modules_tf/rds-cluster-7.0.2//modules/v0.12/rds-cluster/audit-logs-parameters"

  audit_config = local.rds_audit_config
}