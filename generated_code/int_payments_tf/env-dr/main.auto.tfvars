is_dr = true

base_config = {
  env        = "prod2"
  env_type   = "prod"
  region     = "ca-central-1"
  tenant     = "na"
  account_id = "9876543210"
}

provider_config = {
  role_arn     = "arn:aws:iam::9876543210:role/tf"
  session_name = "INT_PAYMENTS_TF"
}

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

  audit_config = {
    enabled = "false"
  }
}

ec = {
  cluster = {
    maintenance_window = "Mon:08:15-Mon:10:15"
    node_type          = "cache.t4g.medium"
    num_cache_nodes    = 2
  }
}