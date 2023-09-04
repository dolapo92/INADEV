## EKS Custer module

## aws get sts-caller-idenity --> aws account number 

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = var.SUBNETS_NAMES
  }
}

data "aws_subnet" "id" {
  for_each = toset(data.aws_subnets.subnets.ids) ## 3 times
  id       = each.value
}



resource "aws_eks_cluster" "control_plane" {
  name     = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.ENV}-cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = var.CLUSTER_VERSION
  vpc_config {
    security_group_ids      = [aws_security_group.k8_sg.id]
    endpoint_private_access = var.PRIVATE_ENDPOINT_ACCESS
    endpoint_public_access  = var.PUBLIC_ENDPOINT_ACCESS
    # public_access_cidrs     = var.PUBLIC_ACCESS_CIDRS
    subnet_ids = [for s in data.aws_subnet.id : s.id]
  }
  enabled_cluster_log_types = ["api"]
  encryption_config {
    provider {
      key_arn = aws_kms_key.key.arn
    }
    resources = ["secrets"]
  }

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.cluster_log]

}

## log group for storing k8s api server logs
resource "aws_cloudwatch_log_group" "cluster_log" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.ENV}-cluster/cluster"
  retention_in_days = 5

  tags = var.tags
}



