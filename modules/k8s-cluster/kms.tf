data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "k8s_kms_policy" {
  statement {
    sid    = "IAM user permissions"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key" "key" {
  description              = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.ENV}-cluster"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy                   = data.aws_iam_policy_document.k8s_kms_policy.json
  enable_key_rotation      = true
  deletion_window_in_days  = 7

  tags = var.tags

}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.ENV}-cluster"
  target_key_id = aws_kms_key.key.key_id
}

