output "alb" {
  value = module.silo.alb
}

output "cluster_arn" {
  value = module.silo.cluster_arn
}{% if cookiecutter.is_apigw == "true" %}

output "api_id" {
  value = module.silo.api_id
}

output "vpc_link_id" {
  value = module.silo.vpc_link_id
}{% endif %}