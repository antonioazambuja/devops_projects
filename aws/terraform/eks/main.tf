provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_security_group" "sg-access" {
    filter {
        name = "group-name"
        values = ["sg-tema20"]
    }
}

data "aws_subnet_ids" "example-subnets" {
  filter {
    name   = "kubernetes.io/cluster/eks-example"
    values = ["shared"]
  }
}


data "aws_security_group" "example" {
    filter {
        name = "group-name"
        values = ["asg-example"]
    }
}

resource "aws_eks_cluster" "example" {
  name     = "eks-example"
  role_arn = aws_iam_role.example.arn
  version  = var.eks_k8s_version

  vpc_config {
    security_group_ids = [data.aws_security_group.example.id]
    subnet_ids = [data.aws_subnet_ids.example-subnets.ids]
  }
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSServicePolicy,
    aws_iam_role.example,
  ]

}

resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Service": "eks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role" "example-node" {
  name = "eks-node-example"

  assume_role_policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "example-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example-node.name
}

resource "aws_iam_role_policy_attachment" "example-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example-node.name
}

resource "aws_iam_role_policy_attachment" "example-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example-node.name
}

resource "aws_eks_node_group" "example-node" {
  cluster_name    = "eks-example"
  node_group_name = "example-node"
  node_role_arn   = aws_iam_role.example-node.arn
  subnet_ids      = [data.aws_subnet_ids.example-subnets.ids]
  instance_types  = ["t2.micro"]

  labels = {
    "component": "elk"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.example-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-node-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.example
  ]
  tags = {
    "kubernetes.io/cluster/eks-example" = "owned"
  }
  remote_access {
    ec2_ssh_key = "example"
    source_security_group_ids = [data.aws_security_group.sg-access.id]
  }
}