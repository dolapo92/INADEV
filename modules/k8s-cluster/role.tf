## This template creates the default IAM role.

## Creating IAM role for Control plane
resource "aws_iam_role" "eks_role" {
  name               = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.AIRPORT_CODE[var.AWS_REGION]}-${var.ENV}-kubernetes-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.tags
}

##Policy attachment for K8s Cluster (Control Plane)
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy-attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy-attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

