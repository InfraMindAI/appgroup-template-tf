is_dr = true

base_silo_state_location = {
  s3_region = "ca-central-1"
  s3_bucket = "terraform-dr"
}

provider_config = {
  role_arn     = "arn:aws:iam::9876543210:role/tf"
  session_name = "{{cookiecutter.services_session_name}}"
}

base_config = {
  account_id = "9876543210"
  env        = "prod2"
  env_type   = "prod"
  tenant     = "na"
  region     = "ca-central-1"
}

services = {
  {{cookiecutter.service_name_underscored}} = {
    service = {
      task_count = 0
    }

    task = {
      cpu    = 1024
      memory = 2048
    }{% if cookiecutter.is_service_rds == "true" %}

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
    }{% endif %}{% if cookiecutter.is_es == "true" %}

    es = {
      cluster = {
        instance_type  = "m6g.large.search"
        instance_count = 1
      }

      ebs = {
        volume_size = 35
      }

      snapshot = {
        automated_snapshot_start_hour = 10
      }

      auto_tune = {
        desired_state = "ENABLED"
      }
    }{% endif %}{% if cookiecutter.ec_service.create == "true" %}

    ec = {
      cluster = {
        maintenance_window = "Mon:08:15-Mon:10:15"
        node_type          = "cache.t4g.medium"
        num_cache_nodes    = 2
      }{% if cookiecutter.ec_service.engine == "redis" %}

      redis = {
        multi_az_enabled         = "true"
        snapshot_retention_limit = 7
        replicas_per_node_group  = 1
      }{% endif %}
    }{% endif %}{% if cookiecutter.is_autoscaling == "true" %}

    autoscaling = {
      resource_based = {
        FILL_ME
      }

      schedule_based = {
        FILL_ME
      }
    }{% endif %}
  }
}