module "ec" {
  source = "../../.modules_tf/ec-7.1.1//modules/v0.12/elasticache"

  name    = local.short_name
  env     = local.env
  subnets = local.subnet_ids

  elasticache          = local.ec_cluster
  route53              = merge(local.ec_route53, {create = "false"})
  security_group_rules = local.ec_security_group_rules
  actions              = local.sns_actions
  cloudwatch           = local.cloudwatch
  tags                 = module.silo_tags.tags
}

module "ec_dns" {
  source = "../../.modules_tf/ec-7.1.1//modules/v0.12/elasticache/elasticache-dns"

  name        = local.short_name
  elasticache = local.ec_cluster
  route53     = merge(local.ec_route53, local.global_dns_defaults)
  endpoint    = module.ec.endpoint
}