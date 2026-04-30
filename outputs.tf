# Explanation: Exports the EKS cluster endpoint.
output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

# Explanation: Exports the EKS cluster certificate authority data.
output "eks_cluster_certificate_authority_data" {
  description = "Certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

# Explanation: Exports the name of the EKS cluster.
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

# Explanation: Exports the public subnet IDs.
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

# Explanation: Exports the EKS worker node security group ID.
output "eks_worker_security_group_id" {
  description = "ID of the EKS worker node security group"
  value       = aws_security_group.eks_worker_sg.id
}

