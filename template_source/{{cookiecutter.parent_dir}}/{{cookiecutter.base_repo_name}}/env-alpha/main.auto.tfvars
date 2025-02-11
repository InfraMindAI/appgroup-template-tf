base_config = {
  env        = "alpha"
  env_type   = "dev"
  region     = "us-east-1"
  tenant     = "na"
  account_id = "1234567890"
}{% if cookiecutter.is_base_rds == "true" %}

rds = {
  cluster = {
    instance_class               = "db.t3.medium"
    preferred_backup_window      = "07:00-08:00"
    preferred_maintenance_window = "Mon:08:15-Mon:10:15"
    count                        = 1
  }

  alarms     = {}
  alerts     = {}
  instances  = {}
  slow_query = {}

  audit_config = {
    enabled = "false"
  }
}{% endif %}{% if cookiecutter.ec_base.create == "true" %}

ec = {
  cluster = {
    maintenance_window = "Mon:08:15-Mon:10:15"
    node_type          = "cache.t4g.micro"
  }{% if cookiecutter.ec_base.engine == "redis" %}

  redis = {
    multi_az_enabled = "false"
  }{% endif %}
}{% endif %}