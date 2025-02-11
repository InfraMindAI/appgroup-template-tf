locals {
  env      = var.base_config["env"]
  env_type = var.base_config["env_type"]

  _task = {
    image_tag = var.base_config["env_tag"]
    app_type  = "java"

    use_rest_host_domain = "true"
    dns_options          = "options timeout:2 attempts:5 ndots:4"
    search_domains       = "${var.is_dr ? "dr." : ""}internal.company.com"
    use_jmx2graphite     = "true"

    java_opts_rewrite = "true"
  }

  _service = {
    is_fargate                  = "true"
    use_task_role_for_execution = "true"
  }

  payment_analysis_service = var.services["payment_analysis"]

  kinesis_cwl_shipper = module.data_only_kinesis_cw_shipper.kinesis_cwl_shipper

  base_logging_config = {
    cwl_shipper_role_arn        = local.kinesis_cwl_shipper["iam"]
    cwl_shipper_destination_arn = local.kinesis_cwl_shipper["stream"]
  }

  cloudwatch = {
    actions_enabled = var.cloudwatch_actions
  }

  private_subnets = join(",", module.data_only_global_private_subnets.subnet_ids)

  cluster = {
    arn        = var.cluster_arn
    vpc_id     = module.data_only_global_vpc.vpc["id"]
    subnet_ids = local.private_subnets
  }

  lb = {
    arn                 = var.alb["arn"]
    subnet_ids          = local.private_subnets
    r53_hosted_zone_id  = local.r53_company_internal_zone_id
    zone_id             = var.alb["zone_id"]
    sg_id               = var.alb["sg_id"]
    dns_name            = var.alb["dns_name"]
    listener_arn        = var.alb["listener_arn"]
    arn_suffix          = var.alb["arn_suffix"]
    access_logs_enabled = local.env_type != "dev" ? "true" : "false"
    create_dns          = "false"
  }

  sns_actions = module.data_only_alert_system.alert_system_arns

  global_secret_policies = module.data_only_global_secret_policies.secrets_policy

  r53_company_internal_zone_id   = module.data_only_r53_global_dns_account.r53_company_internal_zone["zone_id"]
  r53_global_dns_account_zone_id = module.data_only_r53_global_dns_account.r53_global_dns_account_zone["zone_id"]

  vpn_cidr_blocks = [TO_FILL]

  communications_alert_actions = {
    dead_letter_alert  = local.sns_actions["slack_alert"]
    retry_queue_alert  = local.sns_actions["slack_alert"]
    event_alert        = local.sns_actions["slack_alert"]
    dynamodb_alert     = local.sns_actions["slack_alert"]
    topic_backup_alert = local.sns_actions["slack_alert"]
    queue_backup_alert = local.sns_actions["slack_alert"]
  }

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

  secrets_recovery_window_days = var.is_dr ? 0 : 30

  r53_company_internal_zone = module.data_only_r53_global_dns_account.r53_company_com_zone

  _es_dns_entry = {
    r53_zone_id   = local.r53_company_internal_zone["zone_id"]
    r53_zone_name = local.r53_company_internal_zone["name"]
  }

  ec_route53 = {
    zone_id = local.r53_company_internal_zone_id
  }

  ec_security_group_rules = [
    {
      description = "Subnet Silo"
      cidr_blocks = join(",", module.data_only_global_private_subnets.subnet_cidr_blocks)
    },
    {
      description = "ECS Cluster VPC"
      cidr_blocks = join(",", local.vpn_cidr_blocks)
    }
  ]
  
  global_dns_defaults = {
    dns_account_r53_zone_id        = local.r53_global_dns_account_zone_id
    dns_account_r53_hosted_zone_id = local.r53_global_dns_account_zone_id
  }
}

variable "base_config" {
  type = map(any)
}

variable "services" {
  type = object({
    payment_analysis = object({
      task    = map(any)
      service = map(any)

      rds = object({
        alarms       = map(any)
        alerts       = map(any)
        cluster      = map(any)
        instances    = map(any)
        slow_query   = map(any)
        audit_config = map(any)
      })

      es = object({
        ebs       = map(any)
        cluster   = map(any)
        snapshot  = map(any)
        auto_tune = map(any)
      })

      ec = object({
        cluster = map(any)
        redis   = map(any)
      })

      autoscaling = object({
        resource_based = map(any)
        schedule_based = map(any)
      })
    })
  })

  description = "Variables for applications"
}

variable "cloudwatch_actions" {}

variable "cluster_arn" {
  type = string
}

variable "alb" {
  type = map(string)
}

variable "is_dr" {
  type        = bool
  description = "(Optional) If \"true\", specifies does it disaster recovery account or not, Default: \"false\"."
}

variable "rds_snapshot_names" {
  type = object({
    payment_analysis = string
  })

  description = "RDS snapshot name for restoring"
}

variable "api_id" {
  type = string
}

variable "vpc_link_id" {
  type = string
}

variable "ecs_migration" {
  type = map(any)
}