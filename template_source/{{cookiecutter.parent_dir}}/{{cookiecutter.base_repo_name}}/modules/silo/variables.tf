locals {
  name       = "{{cookiecutter.process_name}}"
  short_name = "{{cookiecutter.short_name}}"
  stack_name = "${local.short_name}-${local.env}"

  env      = var.base_config["env"]
  env_type = var.base_config["env_type"]

  vpc_id          = module.data_only_global_vpc.vpc["id"]
  subnet_ids      = module.data_only_global_private_subnets.subnet_ids
  vpn_cidr_blocks = [TO_FILL]{% if cookiecutter.is_base_rds == "true" or cookiecutter.ec_base.create == "true" %}

  r53_company_internal_zone_id   = module.data_only_r53_global_dns_account.r53_company_internal_zone["zone_id"]
  r53_global_dns_account_zone_id = module.data_only_r53_global_dns_account.r53_global_dns_account_zone["zone_id"]{% endif %}

  cloudwatch = {
    actions_enabled = var.cloudwatch_actions
  }

  sns_actions = module.data_only_alert_system.alert_system_arns{% if cookiecutter.is_apigw == "true" %}

  tenant = var.base_config["tenant"]

  domain_name  = "api.${local.env}.company.com"
  allow_origin = "https://${local.env}.company.com"

  cors = {
    enabled       = "true"
    allow_origins = local.allow_origin
    allow_headers = [TO_FILL]
    allow_methods = [TO_FILL]
  }{% endif %}{% if cookiecutter.is_base_rds == "true" %}

  rds_security_group_rules = [
    {
      description = "Subnet Silo"
      type        = "ingress"
      protocol    = "TCP"
      from_port   = "3306"
      to_port     = "3306"
      cidr        = join(",", module.data_only_global_private_subnets.subnet_cidr_blocks)
    }
  ]

  _rds_audit_config = {
    enabled              = "true"
    enable_streaming     = "true"
    audit_log_stream_arn = module.rds_audit_logs_arn.audit_logs_destination_arn
  }

  rds_audit_config = merge(local._rds_audit_config, {exclude_users = FILL_ME}, var.rds["audit_config"])

  _rds_params = [
    {
      name         = "binlog_format"
      value        = "row"
      apply_method = "pending-reboot"
    },
    {
      name         = "performance_schema"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]

  rds_params = concat(module.rds_audit_params.parameters, local._rds_params)

  _rds_cluster = {
    engine_version             = "8.0.mysql_aurora.3.02.2"
    create_cluster_reader_dns  = "false"
    db_event_subscription_name = "${local.name}-${local.env}"
  }

  rds_cluster = merge(local._rds_cluster, var.rds["cluster"]){% endif %}{% if cookiecutter.ec_base.create == "true" %}{% if cookiecutter.ec_base.engine == "redis" %}
  
  _ec_cluster = {
    engine                = "redis"
    engine_version        = "7.0"
    param_group_family    = "redis7"
    create_security_group = "true"
  }

  ec_cluster = merge(local._ec_cluster, var.ec["cluster"])

  _redis = {
    cluster_mode    = "true"
    snapshot_window = "07:00-08:00"
  }

  redis = merge(local._redis, var.ec["redis"]){% elif cookiecutter.ec_base.engine == "memcached" %}

  _ec_cluster = {
    engine                = "memcached"
    engine_version        = "1.6.17"
    param_group_family    = "memcached1.6"
    create_security_group = "true"
  }

  ec_cluster = merge(local._ec_cluster, var.ec["cluster"]){% endif %}

  ec_route53 = {
    zone_id = local.r53_company_internal_zone_id
  }

  global_dns_defaults = {
    dns_account_r53_zone_id        = local.r53_global_dns_account_zone_id
    dns_account_r53_hosted_zone_id = local.r53_global_dns_account_zone_id
  }

  ec_security_group_rules = [
    {
      description = "Subnet Silo"
      cidr_blocks = join(",", module.data_only_global_private_subnets.subnet_cidr_blocks)
    },
    {
      description = "VPN"
      cidr_blocks = join(",", local.vpn_cidr_blocks)
    }
  ]{% endif %}
}

variable "base_config" {
  type = map(any)
}

variable "cloudwatch_actions" {
  type = string
}

variable "is_dr" {
  type        = bool
  description = "(Optional) If \"true\", specifies does it disaster recovery account or not, Default: \"false\"."
}{% if cookiecutter.is_base_rds == "true" %}

variable "rds_snapshot_name" {
  type        = string
  default     = null
  description = "RDS snapshot name for restoring"
}

variable "rds" {
  type = object({
    alarms       = map(any)
    alerts       = map(any)
    cluster      = map(any)
    instances    = map(any)
    slow_query   = map(any)
    audit_config = map(any)
  })

  description = "RDS cluster configuration"
}{% endif %}{% if cookiecutter.ec_base.create == "true" %}

variable "ec" {
  type = map(any)
}{% endif %}