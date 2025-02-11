module "es" {
  source = "../../../.modules_tf/es-3.0.0//modules/v0.12/elasticsearch"

  name              = local.names.kebak_case
  iam_identity_arns = [module.service.iam["task_role"]["arn"]]
  cluster_config    = merge(local._es_cluster, var.es["cluster"])
  ebs_options       = var.es["ebs"]
  snapshot_options  = var.es["snapshot"]
  resource_tags     = module.tags.tags
  dns_entry         = var.es_dns_entry
  base_config       = var.base_config
  sns_actions       = var.actions
  cloudwatch        = local.cloudwatch

  vpc_options = {
    subnet_ids         = split(",", var.cluster["subnet_ids"])[0]
    security_group_ids = aws_security_group.es.id
  }

  auto_tune_options = var.es["auto_tune"]
}

module "es_dns" {
  source = "../../../.modules_tf/es-3.0.0//modules/v0.12/elasticsearch/elasticsearch-dns"

  name              = local.names.kebak_case
  dns_entry_records = [module.es.domain_endpoint]

  dns_entry = merge(var.es_dns_entry, {
    dns_account_r53_zone_id        = var.r53_global_dns_account_zone_id
    dns_account_r53_hosted_zone_id = var.r53_global_dns_account_zone_id
  })
}

resource "aws_security_group" "es" {
  name        = "${local.names.kebak_case}-es"
  description = "Allow traffic to es"
  vpc_id      = var.cluster["vpc_id"]

  tags = module.tags.tags
}

resource "aws_security_group_rule" "es" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  description = "Allow connection to ES cluster"

  security_group_id        = aws_security_group.es.id
  source_security_group_id = module.service.sg.task.id
}

data "aws_iam_policy_document" "es" {

  statement {
    sid = "ElasticSearchBasicAccess"

    actions = [
      "es:ESHttpHead",
      "es:ESHttpPost",
      "es:ESHttpGet",
      "es:ESHttpDelete",
      "es:ESHttpPut"
    ]

    resources = [module.es.domain_arn, "${module.es.domain_arn}/*"]
  }
}