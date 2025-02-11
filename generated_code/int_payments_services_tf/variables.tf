variable "base_silo_state_location" {
  type = map

  default = {
    s3_region = "us-east-1"
    s3_bucket = "terraform"
  }
}

variable provider_config {
  type = map(any)

  default = {
    role_arn     = null
    session_name = null
  }

  description = <<EOF
    role_arn: (Optional) Role arn to assume if required to access the environment
    session_name: (Optional) An identifier for the assumed role session
    dns_role_name: (Optional) Role name to assume in the relevant DNS account
  EOF
}

variable "base_config" {
  type = map(any)

  description = <<EOF
      account_id: (Required) AWS account id.
      env: (Required) The env of the resources.
      env_type: (Required) The env type of the resources. One of "dev", "staging", "prod".
      env_tag: (Required) Docker image tag to be used on our ecs tasks definitions
      region: (Required) AWS Region for the env.
  EOF
}

variable "cloudwatch_actions" {
  type        = string
  default     = "true"
  description = "Cloudwatch actions parameter that will be carried over to all resources. Useful when creating new resources (target should be used)"
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

variable "is_dr" {
  type        = bool
  default     = false
  description = "(Optional) If \"true\", specifies does it disaster recovery account or not, Default: \"false\"."
}

variable "rds_snapshot_names" {
  type = object({
    payment_analysis = string
  })

  default = {
    payment_analysis = null
  }

  description = "RDS snapshot name for restoring"
}

variable "ecs_migration" {
  type = map(any)

  default = {}

  description = <<EOF
    enabled                  : (Optional) If set to \"true\", will create a new ecs service in a different cluster to work with the migration. Default: \"false\"
    app_name                 : (Required if enabled is true) name of the application being migrated
    security_groups          : (Required if enabled is true) segurity group from the service being migrated
    shift_traffic_percentage : (Required if enabled is true) values from 0 to 100, if set will shift the traffic by % from the main service to the newly migrated
    dns                      : (Required if enabled is true) dns from the service lb being migrated to be used to weight the traffic
    task_definition_arn      : (Optional) task_definition_arn from the service being migrated
    iam_role_task_arn        : (Optional) iam_role_task_arn from the service being migrated
    iam_role_task_id         : (Optional) iam_role_task_id from the service being migrated
    zone_id                  : (Optional) zone_id from the service lb being migrated to be used to weight the traffic
  EOF
}