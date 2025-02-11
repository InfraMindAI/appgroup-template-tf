output "alb" {
  value = {
    arn          = module.ecs_cluster.alb_arn
    arn_suffix   = module.ecs_cluster.alb_arn_suffix
    listener_arn = module.ecs_cluster.alb_listener_arn
    sg_id        = module.ecs_cluster.alb_sg_id
    zone_id      = module.ecs_cluster.alb_zone_id
    dns_name     = module.ecs_cluster.alb_dns
  }
}

output "cluster_arn" {
  value = module.ecs_cluster.cluster_arn
}{% if cookiecutter.is_apigw == "true" %}

output "api_id" {
  value = module.apigw.api_gw_v2["id"]
}

output "vpc_link_id" {
  value = module.vpc_link.vpc_link
}{% endif %}