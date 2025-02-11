module "ec" {
  source = "../../../.modules_tf/ec-7.1.1//modules/v0.12/elasticache"

  name    = local.names.kebak_case
  env     = local.env
  subnets = split(",", var.cluster["subnet_ids"])

  elasticache          = local.ec_cluster
  redis                = local.redis
  route53              = merge(var.ec_route53, {create = "false"})
  security_group_rules = var.ec_security_group_rules
  actions              = var.actions
  cloudwatch           = local.cloudwatch
  tags                 = module.tags.tags
}

module "ec_dns" {
  source = "../../../.modules_tf/ec-7.1.1//modules/v0.12/elasticache/elasticache-dns"

  name        = local.names.kebak_case
  elasticache = local.ec_cluster
  route53     = merge(var.ec_route53, var.global_dns)
  endpoint    = module.ec.endpoint
}