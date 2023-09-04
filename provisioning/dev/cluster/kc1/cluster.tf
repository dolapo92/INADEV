## EKS Control Plane provisioning
module "control-plane" {
  source                  = "../../../../modules/k8s-cluster"
  PRODUCT_NAME            = "poc"
  CLUSTER_ALAIAS          = "kc1"
  ENV                     = "dev"
  CLUSTER_VERSION         = 1.25
  AWS_REGION              = "us-east-2"
  PRIVATE_ENDPOINT_ACCESS = false
  PUBLIC_ENDPOINT_ACCESS  = true
  VPC_NAME                = ["Default"]
  SUBNETS_NAMES           = ["Public-subnet-1", "Public-subnet-2", "Public-subnet-3"]


  tags = {
    Purpose    = "EKS-Cluster"
    Managed-by = "Terraform"
  }
}
