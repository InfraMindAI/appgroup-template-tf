module "sqs" {
  source = "../../../.modules_tf/sqs-6.2.0//modules/v0.12/sqs/queue"

  app_name      = local.names.snake_case
  env           = local.env
  queues        = local.sqs_queues
  alert_actions = var.alert_actions
  tags          = module.tags.tags
}

resource "aws_iam_policy_attachment" "sqs_queues" {
  for_each   = module.sqs.iam_policies
  name       = "${local.names.kebak_case}-sqs-${each.key}"
  roles      = [module.service.iam["task_role"]["id"]]
  policy_arn = each.value.arn
}