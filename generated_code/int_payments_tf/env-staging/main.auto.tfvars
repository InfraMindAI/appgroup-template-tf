base_config = {
  env        = "staging"
  env_type   = "staging"
  region     = "us-west-1"
  tenant     = "na"
  account_id = "1234567890"
}

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
}

ec = {
  cluster = {
    maintenance_window = "Mon:08:15-Mon:10:15"
    node_type          = "cache.t4g.micro"
    num_cache_nodes    = 2
  }
}