module "dynamo_table" {
  source = "../../../.modules_tf/dynamodb-4.1.0//modules/v0.12/dynamodb"

  env           = local.env
  resource_tags = module.tags.tags
  sns_actions   = var.actions
  cloudwatch    = var.cloudwatch

  configs = FILL_ME

  attributes = FILL_ME
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    sid = "DynamodbBasicAccess"

    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]

    resources = [
      module.dynamo_table.table_arn,
      "${module.dynamo_table.table_arn}/*"
    ]
  }
}