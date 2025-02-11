base_config = {
  env        = "prod1"
  env_type   = "prod"
  region     = "us-west-2"
  tenant     = "na"
  account_id = "1234567890"
}{% if cookiecutter.is_base_rds == "true" %}

rds = {
  cluster = {
    instance_class               = "db.r5.large"
    preferred_backup_window      = "07:00-08:00"
    preferred_maintenance_window = "Mon:08:15-Mon:10:15"
    count                        = 2
  }

  alarms = {
    cpu_alarm_threshold_writer     = 75
    cpu_evaluation_periods_writer  = 2
    cpu_datapoints_to_alarm_writer = 2
  }

  alerts = {
    cpu_alert_threshold_writer           = 65
    cpu_alert_evaluation_periods_writer  = 2
    cpu_alert_datapoints_to_alarm_writer = 2
  }

  slow_query = {
    alarm_threshold = 10
  }

  instances = {}

  audit_config = {}
}{% endif %}{% if cookiecutter.ec_base.create == "true" %}

ec = {
  cluster = {
    maintenance_window = "Mon:08:15-Mon:10:15"
    node_type          = "cache.t4g.medium"
    num_cache_nodes    = 2
  }{% if cookiecutter.ec_base.engine == "redis" %}

  redis = {
    multi_az_enabled         = "true"
    snapshot_retention_limit = 7
    replicas_per_node_group  = 1
  }{% endif %}
}{% endif %}