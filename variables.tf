# Explanation: The AWS region where the EKS cluster will be deployed.
variable "aws_region" {
  description = "The AWS region to deploy the EKS cluster in"
  type        = string
  default     = "us-east-1"
}

# Explanation: Name for your EKS cluster.
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-k8s-cluster"
}

# Explanation: Desired number of worker nodes.
variable "desired_nodes" {
  description = "The desired number of worker nodes for the EKS cluster"
  type        = number
  default     = 2
}

# Explanation: EC2 instance type for worker nodes. 't3.medium' is a good balance.
variable "instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium" # t2.medium might be free tier, but t3.medium is often better for K8s
}

# Explanation: CIDR block for the VPC.
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Explanation: Names for public subnets.
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Explanation: Name for the SSH key pair to access worker nodes (optional, but good for debugging).
# You MUST create this key pair in AWS beforehand or adapt this.
variable "key_pair_name" {
  description = "The name of the SSH key pair for worker nodes (optional)"
  type        = string
  default     = "" # Leave empty if you don't want SSH access, or provide your key name
}

