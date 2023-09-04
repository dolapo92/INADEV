#Note: Do not change the resource name for the eks cluster.
#Note: Do not change the name of the resource and sg_name variable -> it destroys the EKS cluster and recreates.

## Security Groups
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = var.VPC_NAME
  }
}

## Creating security Group for master {Control Plane}
resource "aws_security_group" "k8_sg" {
  vpc_id      = data.aws_vpc.vpc.id
  name        = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.AIRPORT_CODE[var.AWS_REGION]}-${var.ENV}-cluster-sg"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PRODUCT_NAME}-${var.CLUSTER_ALAIAS}-${var.AIRPORT_CODE[var.AWS_REGION]}-${var.ENV}-cluster-sg"
  }
}

resource "aws_security_group_rule" "k8-cluster-ingress-workstation" {
  cidr_blocks       = ["172.31.0.0/16"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 0
  protocol          = -1
  security_group_id = aws_security_group.k8_sg.id
  to_port           = 0
  type              = "ingress"
}
