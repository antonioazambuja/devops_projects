variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {}

variable "eks_k8s_version" {
  default = "1.14"
}

variable "eks_cluster_name" {
  default = "eks-example"
}

