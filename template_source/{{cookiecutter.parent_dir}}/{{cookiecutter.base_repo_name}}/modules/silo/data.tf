module "silo_tags" {
  source = "../../.modules_tf/do-resource-tags-1.2.0//modules/data/resource-tags"

  env     = local.env
  feature = replace(local.name, "-", "")
}

module "data_only_global_private_subnets" {
  source = "../../.modules_tf/do-appgroup-subnets-1.0.0//modules/data/appgroup/subnets"

  vpc_id   = module.data_only_global_vpc.vpc["id"]
  appgroup = local.name
}

module "data_only_global_vpc" {
  source = "../../.modules_tf/do-global-vpc-1.0.0//modules/data/global-vpc"

  base_config = var.base_config
}

module "data_only_alert_system" {
  source = "../../.modules_tf/do-alert-system-1.0.0//modules/data/alert-system"

  env = local.env
}{% if cookiecutter.is_base_rds == "true"%}

module "rds_audit_logs_arn" {
  source = "../../.modules_tf/rds-cluster-7.0.2//modules/v0.12/rds-cluster/audit-logs-stream-arn"

  base_config = var.base_config
}{% endif %}{% if cookiecutter.is_base_rds == "true" or cookiecutter.ec_base.create == "true" %}

module "data_only_r53_global_dns_account" {
  source = "../../.modules_tf/do-route53-zone-1.1.0//modules/data/r53/route53-zone"

  env        = local.env
  dr_account = tostring(var.is_dr)
}{% endif %}