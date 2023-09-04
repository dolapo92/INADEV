data "aws_caller_identity" "current" {}

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

resource "aws_eks_node_group" "worker_node" {
  cluster_name    = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.ENV}-cluster"
  node_group_name = var.NODE_GROUP_NAME
  node_role_arn   = aws_iam_role.node-group-role.arn
  subnet_ids      = [for s in data.aws_subnet.id : s.id]
  instance_types  = var.INSTANCE_TYPE
  disk_size       = var.DISK_SIZE
  ami_type        = var.AMI_TYPE
  capacity_type   = var.CAPACITY_TYPE
  release_version = var.AMI_VERSION

  tags = var.tags

  labels = var.labels


  scaling_config {
    desired_size = var.DESIRED_INSTANCE
    max_size     = var.MAX_INSTANCE
    min_size     = var.MIN_INSTANCE
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
