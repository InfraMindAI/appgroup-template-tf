module "service" {
  source = "../../../.modules_tf/ecs-service-13.0.1//modules/v0.12/ecs-service"

  base_config    = var.base_config
  vpn            = var.vpn_cidr_blocks
  cluster_config = var.cluster
  lb_config      = {% if cookiecutter.is_api == "true" %}local.lb{% else %}var.lb{% endif %}
  service_config = local.service
  task_config    = var.task
  task_policies  = local.task_policies
  tg_config      = { health_check_path = "/q/health" }

  actions        = var.actions
  cloudwatch     = local.cloudwatch
  logging        = var.logging
  resource_tags  = module.tags.tags
  secrets        = local.secrets
  is_dr          = var.use_account_alias{% if cookiecutter.is_ecs_migration == "true" %}
  ecs_migration  = local.ecs_migration{% endif %}{% if cookiecutter.is_autoscaling == "true" %}

  resource_based_autoscaling = var.autoscaling["resource_based"]
  schedule_based_autoscaling = var.autoscaling["schedule_based"]{% endif %}
}

module "service_dns" {
  source = "../../../.modules_tf/ecs-service-13.0.1//modules/v0.12/ecs-service/ecs-service-dns"

  base_config    = var.base_config
  service_config = {name = local.names.kebak_case}

  lb_config = merge(var.lb, {
    create_dns                     = "true"
    dns_account_r53_hosted_zone_id = var.r53_global_dns_account_zone_id
  }){% if cookiecutter.is_ecs_migration == "true" %}

  ecs_migration = local.ecs_migration{% endif %}
}

module "parameters" {
  source = "../../../.modules_tf/config-2.1.1//modules/v0.12/config"

  base_config   = var.base_config
  resource_tags = module.tags.tags
  app_name      = local.names.kebak_case

  ssm_parameter_configs = {
    app_config = {
      parameter_name = "app-config"
    }

    java_opts = {
      parameter_name = "java/java_opts"
    }
  }
}

module "config_param_policy" {
  source = "../../../.modules_tf/config-2.1.1//modules/v0.12/config/param-policy"

  base_config = var.base_config

  iam_config = {
    app_name = local.names.kebak_case
  }
}{% if cookiecutter.is_rds_secret == "true" %}

module "rds_secret" {
  source = "../../../.modules_tf/secret-1.3.0//modules/v0.12/secret"

  base_config = var.base_config

  secret_config = {
    app_name                = local.names.kebak_case
    secret_name             = "rds/${local.names.kebak_case}"
    recovery_window_in_days = var.secrets_recovery_window_days
  }

  resource_tags = module.tags.tags
}{% endif %}