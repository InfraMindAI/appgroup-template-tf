variable "provider_config" {
  type = map(any)

  default = {
    role_arn     = null
    session_name = null
  }

  description = <<EOF
    region: (Required) The provider region.
    role_arn: (Required) The provider iam role arn.
    session_name: (Required) The provider session name.
    dns_role_name: (Optional) Role name to assume in the relevant DNS account
  EOF
}

variable "base_config" {
  type        = map(string)
  description = "Base configuration for envs"
}

variable "cloudwatch_actions" {
  type    = string
  default = "true"
}

variable "is_dr" {
  type        = bool
  default     = false
  description = "(Optional) If \"true\", specifies does it disaster recovery account or not, Default: \"false\"."
}{% if cookiecutter.is_base_rds == "true" %}

variable "rds_snapshot_name" {
  type        = string
  default     = null
  description = "RDS snapshot name for restoring"
}

variable "rds" {
  type = object({
    alarms = map(any)
    alerts = map(any)
    cluster = map(any)
    instances = map(any)
    slow_query = map(any)
    audit_config = map(any)
  })

  description = "RDS cluster configuration"
}{% endif %}{% if cookiecutter.ec_base.create == "true" %}

variable "ec" {
  type = map(any)
}{% endif %}