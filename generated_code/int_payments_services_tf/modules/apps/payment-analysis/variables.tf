locals {
  _name = "payment analysis"
  names = {
    no_case    = replace(local._name, " ", "")
    kebak_case = replace(local._name, " ", "-")
    snake_case = replace(local._name, " ", "_")
  }

  env = var.base_config["env"]

  task_policies = [
    module.config_param_policy.iam["policy_json"],
    module.service.amazon_ecs_task_execution_role_policy["policy_json"],
    var.global_secret_policies["global/security/logging"],
    data.aws_iam_policy_document.dynamodb.json,
    data.aws_iam_policy_document.es.json
  ]
  
  _lb = {
    is_http_api = "true"
  }

  lb = merge(var.lb, local._lb)
  
  _service = {
    name = local.names.kebak_case
    port = FILL_ME
  }

  service = merge(local._service, var.service)

  ecs_migration = merge(var.ecs_migration, {
    enabled = lookup(var.ecs_migration, "app_name", "") == local.names.kebak_case
  })

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

  cloudwatch = merge(local._cloudwatch, var.cloudwatch)

  _es_cluster = {
    version                = "OpenSearch_1.3"
    encrypt_at_rest        = "true"
    zone_awareness_enabled = "false"
  }

  sqs_queues = FILL_ME

  _rds_cluster = {
    engine_version             = "8.0.mysql_aurora.3.02.2"
    create_cluster_reader_dns  = "false"
    db_event_subscription_name = "${local.names.kebak_case}-${local.env}"
  }

  rds_cluster = merge(local._rds_cluster, var.rds["cluster"])

  rds_params       = concat(module.rds_audit_params.parameters, var._rds_params)
  rds_audit_config = merge(var._rds_audit_config, {exclude_users = FILL_ME}, var.rds["audit_config"])

  _apigw_cloudwatch = {
    actions_enabled   = var.cloudwatch["actions_enabled"]
    create_5xx_alarms = "true"
    create_4xx_alarms = "true"
  }

  apigw_routes = FILL_ME
  
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

  redis = merge(local._redis, var.ec["redis"])
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
}

variable "autoscaling" {
  type = map(any)
}

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
}

variable "alert_actions" {
  type = map(string)
}

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
}

variable "es" {
  type = object({
    ebs       = map(any)
    cluster   = map(any)
    snapshot  = map(any)
    auto_tune = map(any)
  })
}

variable "es_dns_entry" {}

variable "api_id" {
  type = string
}

variable "vpc_link_id" {
  type = string
}

variable "secrets_recovery_window_days" {
  type = number
}

variable "ecs_migration" {
  type = map(any)
}

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
}