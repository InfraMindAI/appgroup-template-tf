locals {
  _name = "{{cookiecutter.service_name_spaces}}"
  names = {
    no_case    = replace(local._name, " ", "")
    kebak_case = replace(local._name, " ", "-")
    snake_case = replace(local._name, " ", "_")
  }

  env = var.base_config["env"]

  task_policies = [
    module.config_param_policy.iam["policy_json"],
    module.service.amazon_ecs_task_execution_role_policy["policy_json"],
    var.global_secret_policies["global/security/logging"]{% if cookiecutter.is_dynamo == "true" %},
    data.aws_iam_policy_document.dynamodb.json{% endif %}{% if cookiecutter.is_es == "true" %},
    data.aws_iam_policy_document.es.json{% endif %}
  ]
  {% if cookiecutter.is_api == "true" %}
  _lb = {
    is_http_api = "true"
  }

  lb = merge(var.lb, local._lb)
  {% endif %}
  _service = {
    name = local.names.kebak_case
    port = FILL_ME
  }

  service = merge(local._service, var.service){% if cookiecutter.is_ecs_migration == "true" %}

  ecs_migration = merge(var.ecs_migration, {
    enabled = lookup(var.ecs_migration, "app_name", "") == local.names.kebak_case
  }){% endif %}

  secrets = [
    {
      name = "JAVA_OPTS",
      arn  = module.parameters.parameters["java_opts"]["arn"]
    }
  ]

  is_prod_env_type = var.base_config["env_type"] == "prod"

  _cloudwatch = {
    create_max_cpu_util_alarm     = local.is_prod_env_type ? "false" : "true"
    create_adv_max_cpu_util_alarm = local.is_prod_env_type ? "true" : "false"
  }

  cloudwatch = merge(local._cloudwatch, var.cloudwatch){% if cookiecutter.is_es == "true" %}

  _es_cluster = {
    version                = "OpenSearch_1.3"
    encrypt_at_rest        = "true"
    zone_awareness_enabled = "false"
  }{% endif %}{% if cookiecutter.is_sqs == "true" %}

  sqs_queues = FILL_ME{% endif %}{% if cookiecutter.is_service_rds == "true" %}

  _rds_cluster = {
    engine_version             = "8.0.mysql_aurora.3.02.2"
    create_cluster_reader_dns  = "false"
    db_event_subscription_name = "${local.names.kebak_case}-${local.env}"
  }

  rds_cluster = merge(local._rds_cluster, var.rds["cluster"])

  rds_params       = concat(module.rds_audit_params.parameters, var._rds_params)
  rds_audit_config = merge(var._rds_audit_config, {exclude_users = FILL_ME}, var.rds["audit_config"]){% endif %}{% if cookiecutter.is_apigw == "true" %}

  _apigw_cloudwatch = {
    actions_enabled   = var.cloudwatch["actions_enabled"]
    create_5xx_alarms = "true"
    create_4xx_alarms = "true"
  }

  apigw_routes = FILL_ME{% endif %}{% if cookiecutter.ec_service.create == "true" %}{% if cookiecutter.ec_service.engine == "redis" %}
  
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

  redis = merge(local._redis, var.ec["redis"]){% elif cookiecutter.ec_service.engine == "memcached" %}

  _ec_cluster = {
    engine                = "memcached"
    engine_version        = "1.6.17"
    param_group_family    = "memcached1.6"
    create_security_group = "true"
  }

  ec_cluster = merge(local._ec_cluster, var.ec["cluster"]){% endif %}{% endif %}
}

variable "base_config" {
  type = map(string)
}

variable "cluster" {
  type = map(string)
}

variable "service" {
  type        = map(any)
  description = "Application configuration"
}

variable "task" {
  type = map(any)
}{% if cookiecutter.is_autoscaling == "true" %}

variable "autoscaling" {
  type = map(any)
}{% endif %}

variable "lb" {
  type = map(string)
}

variable "logging" {
  type = map(string)
}

variable "global_secret_policies" {
  type = map(string)
}

variable "actions" {
  type = map(string)
}

variable "cloudwatch" {
  type = map(string)
}

variable "r53_global_dns_account_zone_id" {
  type = string
}

variable "use_account_alias" {
  type = bool
}

variable "vpn_cidr_blocks" {
  type = list(string)
}{% if cookiecutter.is_sqs == "true" %}

variable "alert_actions" {
  type = map(string)
}{% endif %}{% if cookiecutter.is_service_rds == "true" %}

variable "rds" {
  type = map(any)
}

variable "rds_security_group_rules" {
  type = list(any)
}

variable "_rds_audit_config" {
  type = map(string)
}

variable "_rds_params" {
}

variable "rds_snapshot_name" {
  type        = string
  description = "RDS snapshot name for restoring"
}{% endif %}{% if cookiecutter.is_es == "true" %}

variable "es" {
  type = object({
    ebs       = map(any)
    cluster   = map(any)
    snapshot  = map(any)
    auto_tune = map(any)
  })
}

variable "es_dns_entry" {}{% endif %}{% if cookiecutter.is_apigw == "true" %}

variable "api_id" {
  type = string
}

variable "vpc_link_id" {
  type = string
}{% endif %}{% if cookiecutter.is_rds_secret == "true" %}

variable "secrets_recovery_window_days" {
  type = number
}{% endif %}{% if cookiecutter.is_ecs_migration == "true" %}

variable "ecs_migration" {
  type = map(any)
}{% endif %}{% if cookiecutter.ec_service.create == "true" %}

variable "ec" {
  type = map(any)
}

variable "ec_security_group_rules" {
  type = list(any)
}

variable "ec_route53" {
  type = map(any)
}

variable "global_dns" {
  type = map(any)
}{% endif %}