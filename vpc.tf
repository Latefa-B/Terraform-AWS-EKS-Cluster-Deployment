# Explanation: Defines the Virtual Private Cloud (VPC) where our EKS cluster will reside.
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Explanation: Creates public subnets across different Availability Zones for high availability.
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true # Worker nodes in these subnets will get public IPs
  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index}"
    # Required tags for EKS auto-discovery of subnets
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1" # Tag for ELB auto-discovery
  }
}

# Explanation: Data source to get available Availability Zones in the region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Explanation: Internet Gateway for outbound internet access from public subnets.
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Explanation: Route table for public subnets to route traffic to the Internet Gateway.
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

# Explanation: Associate public subnets with the public route table.
resource "aws_route_table_association" "eks_public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.eks_public_rt.id
}

# Explanation: Security group for the EKS Control Plane.
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Cluster security group for EKS"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere to the control plane (for kubectl)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

