module "silo" {
  source = "../modules/silo"

  is_dr              = var.is_dr
  base_config        = var.base_config
  cloudwatch_actions = var.cloudwatch_actions{% if cookiecutter.is_base_rds == "true" %}

  rds               = var.rds
  rds_snapshot_name = var.rds_snapshot_name{% endif %}{% if cookiecutter.ec_base.create == "true" %}

  ec = var.ec{% endif %}
}