module api_integration {
  source = "../../../.modules_tf/apigw-5.2.0//modules/v0.12/apigw/v2/integration"

  api_id               = var.api_id
  vpc_link_id          = var.vpc_link_id
  integration_uri      = module.service.http_api_lb_listener_arn
  timeout_milliseconds = 5000
}

module api_routes {
  source = "../../../.modules_tf/apigw-5.2.0//modules/v0.12/apigw/v2/routes"

  api_id                 = var.api_id
  default_integration_id = module.api_integration.id
  cloudwatch             = local._apigw_cloudwatch
  actions                = var.actions

  routes        = local.apigw_routes
  base_config   = var.base_config
  resource_tags = module.tags.tags
}