# Explanation: Defines the EKS Kubernetes cluster itself.
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28" # Specify Kubernetes version. Check EKS supported versions.

  vpc_config {
    subnet_ids         = aws_subnet.public_subnets[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  tags = {
    Name = var.cluster_name
  }

  # Explanation: Depends on the IAM role and VPC resources being created first.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_cluster_vpc_resource_controller_attachment,
  ]
}

