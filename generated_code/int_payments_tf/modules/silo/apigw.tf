module "apigw" {
  source = "../../.modules_tf/apigw-5.2.0//modules/v0.12/apigw/v2"

  name = local.name
  cors = local.cors

  base_config   = var.base_config
  resource_tags = module.silo_tags.tags

  api_mapping = {
    domain_name = local.domain_name
    mapping_key = FILL_ME
  }

  default_route_settings = {
    detailed_metrics_enabled = "true"
  }
}

module "vpc_link" {
  source = "../../.modules_tf/apigw-5.2.0//modules/v0.12/apigw/v2/vpc-link"

  name          = local.name
  subnet_ids    = module.data_only_global_private_subnets.subnet_ids
  base_config   = var.base_config
  resource_tags = module.silo_tags.tags
}