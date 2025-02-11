base_config = {
  account_id = "1234567890"
  env        = "staging"
  env_type   = "staging"
  tenant     = "na"
  region     = "us-west-1"
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
        instance_class               = "db.t3.medium"
        preferred_backup_window      = "07:00-08:00"
        preferred_maintenance_window = "Mon:08:15-Mon:10:15"
        count                        = 2
      }

      alarms       = {}
      alerts       = {}
      instances    = {}
      slow_query   = {}
      audit_config = {}
    }{% endif %}{% if cookiecutter.is_es == "true" %}

    es = {
      cluster = {
        instance_type  = "t3.medium.elasticsearch"
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
        node_type          = "cache.t4g.micro"
        num_cache_nodes    = 2
      }{% if cookiecutter.ec_service.engine == "redis" %}

      redis = {
        multi_az_enabled = "false"
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