module "{{cookiecutter.service_name_underscored}}" {
  source = "./{{cookiecutter.service_name}}"

  task                           = merge(local._task, local.{{cookiecutter.service_name_underscored}}_service["task"])
  service                        = merge(local._service, local.{{cookiecutter.service_name_underscored}}_service["service"])
  cluster                        = local.cluster{% if cookiecutter.is_autoscaling == "true" %}
  autoscaling                    = local.{{cookiecutter.service_name_underscored}}_service["autoscaling"]{% endif %}{% if cookiecutter.is_ecs_migration == "true" %}
  ecs_migration                  = var.ecs_migration{% endif %}
  base_config                    = var.base_config
  lb                             = local.lb
  logging                        = local.base_logging_config
  actions                        = local.sns_actions
  cloudwatch                     = local.cloudwatch
  use_account_alias              = var.is_dr
  global_secret_policies         = local.global_secret_policies
  r53_global_dns_account_zone_id = local.r53_global_dns_account_zone_id{% if cookiecutter.is_rds_secret == "true" %}
  secrets_recovery_window_days   = local.secrets_recovery_window_days{% endif %}
  vpn_cidr_blocks                = local.vpn_cidr_blocks{% if cookiecutter.is_sqs == "true" %}
  alert_actions                  = local.communications_alert_actions{% endif %}{% if cookiecutter.is_service_rds == "true" %}

  rds                      = local.{{cookiecutter.service_name_underscored}}_service["rds"]
  _rds_params              = local._rds_params
  _rds_audit_config        = local._rds_audit_config
  rds_snapshot_name        = var.rds_snapshot_names["{{cookiecutter.service_name_underscored}}"]
  rds_security_group_rules = local.rds_security_group_rules{% endif %}{% if cookiecutter.is_es == "true" %}

  es           = local.{{cookiecutter.service_name_underscored}}_service["es"]
  es_dns_entry = local._es_dns_entry{% endif %}{% if cookiecutter.is_apigw == "true" %}

  api_id      = var.api_id
  vpc_link_id = var.vpc_link_id{% endif %}{% if cookiecutter.ec_service.create == "true" %}

  ec                      = local.{{cookiecutter.service_name_underscored}}_service["ec"]
  ec_security_group_rules = local.ec_security_group_rules
  ec_route53              = local.ec_route53
  global_dns              = local.global_dns_defaults{% endif %}
}