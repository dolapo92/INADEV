## Creating IAM role for node group
resource "aws_iam_role" "node-group-role" {
  name                = "eks-${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.AIRPORT_CODE[var.AWS_REGION]}-${var.ENV}-node-${var.NODE_GROUP_NAME}-role"
  managed_policy_arns = var.MANAGED_POLICY
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
    }]
    Version = "2012-10-17"
  })
}

## Pre-defined Policy attachment for nodegroups
resource "aws_iam_role_policy_attachment" "nodegroup-policy-attachment" {
  role       = aws_iam_role.node-group-role.name
  policy_arn = aws_iam_policy.k8s_policy.arn
}

## EKSWorkerNodePolicy Attachment
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

## EKS_CNI_Policy
resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

## EC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "custompolicy" {
  role       = aws_iam_role.node-group-role.name
  policy_arn = aws_iam_policy.k8s_policy.arn
}

resource "aws_iam_role_policy_attachment" "userpolicy" {
  count      = fileexists("policy.json") ? 1 : 0
  role       = aws_iam_role.node-group-role.name
  policy_arn = aws_iam_policy.user-policy[count.index].arn
}
