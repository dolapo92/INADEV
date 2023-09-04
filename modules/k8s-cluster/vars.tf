## Variables

variable "PRODUCT_NAME" {
  type    = string
  default = "poc"
}

variable "CLUSTER_ALAIAS" {
  type    = string
  default = "kc1"
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

variable "ENV" {
  type    = string
  default = "dev"
}

variable "PRIVATE_ENDPOINT_ACCESS" {
  type    = bool
  default = false
}

variable "PUBLIC_ENDPOINT_ACCESS" {
  type    = bool
  default = true
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}

variable "CLUSTER_VERSION" {
  default = "1.25"
}

variable "tags" {
  type = map(string)
}

variable "SUBNETS_NAMES" {
  type = list(string)
}

# variable "PUBLIC_ACCESS_CIDRS" {} # Required field

variable "VPC_NAME" {} # Required field


