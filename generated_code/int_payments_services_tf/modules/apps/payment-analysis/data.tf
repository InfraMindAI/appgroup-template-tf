module "tags" {
  source = "../../../.modules_tf/do-resource-tags-1.2.0//modules/data/resource-tags"

  env     = local.env
  feature = local.names.no_case
}