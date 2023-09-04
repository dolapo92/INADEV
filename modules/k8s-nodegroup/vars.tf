## Variables

variable "NODE_GROUP_NAME" {
  type = string
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}

variable "AIRPORT_CODE" {
  type = map(string)
  default = {
    us-west-2      = "pdx"
    us-east-1      = "iad"
    us-east-2      = "cvg"
    us-west-1      = "sfo"
    ca-central-1   = "yul"
    sa-east-1      = "gru"
    eu-central-1   = "fra"
    eu-west-2      = "lhr"
    eu-west-1      = "dub"
    ap-south-1     = "bon"
    ap-northeast-2 = "icn"
    ap-northeast-1 = "hnd"
    ap-southeast-2 = "syd"
    ap-southeast-1 = "sin"
  }
}

variable "SUBNETS_NAMES" {
  type = list(string)
}

variable "INSTANCE_TYPE" {
  default = "t3.medium"
}

variable "DISK_SIZE" {
  type    = number
  default = 8
}

variable "DESIRED_INSTANCE" {
  type    = number
  default = 1
}

variable "MAX_INSTANCE" {
  default = 2
}

variable "MIN_INSTANCE" {
  default = 1
}

variable "PRODUCT_NAME" {
  type    = string
  default = "poc"
}

variable "CLUSTER_ALAIAS" {
  type    = string
  default = "kc1"
}

variable "ENV" {
  type    = string
  default = "dev"
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "MANAGED_POLICY" {
  type    = list(string)
  default = null
}

variable "IAM_POLICY" {
  default = null
}

variable "AMI_TYPE" {
  default = null
}

variable "CAPACITY_TYPE" {
  default = null
}

variable "AMI_VERSION" {
  default = null
}

variable "tags" {
  type = map(string)
}