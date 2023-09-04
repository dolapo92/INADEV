## EKS Nodegroup

module "worker-node-1" {
  source          = "../../../../modules/k8s-nodegroup"
  PRODUCT_NAME    = "poc" # ClusterName
  CLUSTER_ALAIAS  = "kc1" # Cluster Alias
  NODE_GROUP_NAME = "infra"
  INSTANCE_TYPE   = ["t3.medium"] # default t3.medium
  AMI_TYPE        = "AL2_x86_64"  # Optional Non GPU Instance, AL2_x86_64_GPU for GPU instance
  CAPACITY_TYPE   = "ON_DEMAND"   # Optional
  #AMI_VERSION     = "" # Optional https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
  DISK_SIZE        = 30 # default 8
  DESIRED_INSTANCE = 1  # default 1
  MAX_INSTANCE     = 2  # default 2
  MIN_INSTANCE     = 1  # default 1
  ENV              = "dev"
  AWS_REGION       = "us-east-2"
  SUBNETS_NAMES    = ["Public-subnet-1", "Public-subnet-2", "Public-subnet-3"]
  MANAGED_POLICY   = ["arn:aws:iam::aws:policy/SecretsManagerReadWrite"]    # in case user need managed policy
  IAM_POLICY       = fileexists("policy.json") ? file("policy.json") : null ## user based custom policy
  labels = {
    stack = "infra"
  }
  tags = {
    Purpose    = "EKS-Cluster"
    Managed-by = "Terraform"
  }

  depends_on = [module.control-plane]
}
