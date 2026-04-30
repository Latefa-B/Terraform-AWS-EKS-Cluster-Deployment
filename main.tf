# Explanation: Specifies the required Terraform providers and their versions.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Required for interacting with the K8s API
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # Used for generating private keys for SSH
    }
  }
}

# Explanation: Configures the AWS provider with the specified region.
provider "aws" {
  region = var.aws_region
}

# Explanation: Configures the Kubernetes provider to connect to our EKS cluster.
# It dynamically gets credentials from the AWS CLI.
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name, "--region", var.aws_region]
  }
}

# Explanation: Configures the TLS provider for key generation.
provider "tls" {}

