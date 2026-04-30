# Explanation: Security group for the EKS Worker Nodes.
resource "aws_security_group" "eks_worker_sg" {
  name        = "${var.cluster_name}-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.eks_vpc.id

  # Allow inbound from EKS cluster control plane
  ingress {
    from_port   = 9443 # EKS control plane to nodes
    to_port     = 9443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  # Allow inbound from other worker nodes (for Pod-to-Pod communication)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    self        = true # From itself (other instances in this SG)
  }

  # Allow inbound from ALB for applications (if using ALB)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed for your ALB/Ingress
  }

  # Allow SSH access to worker nodes (optional, if key_pair_name is set)
  dynamic "ingress" {
    for_each = var.key_pair_name != "" ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Be careful: allows SSH from anywhere!
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.cluster_name}-worker-sg"
  }
}

# Explanation: Creates an EC2 Launch Template for the worker nodes.
resource "aws_launch_template" "eks_worker_lt" {
  name_prefix   = "${var.cluster_name}-worker-lt-"
  image_id      = data.aws_ami.eks_worker_ami.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name # If you provided a key pair name
  vpc_security_group_ids = [aws_security_group.eks_worker_sg.id]
  user_data     = base64encode(local.eks_node_user_data) # Script to join cluster

  block_device_mappings {
    device_name = "/dev/xvda" # Or /dev/sda1 depending on AMI
    ebs {
      volume_size = 20 # GB, adjust as needed
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-worker"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned" # Required for EKS auto-discovery
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.cluster_name}-worker-volume"
    }
  }
}

# Explanation: Local variable to generate the user_data script for worker nodes.
# This script makes the EC2 instances join the EKS cluster.
locals {
  eks_node_user_data = <<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name} --kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=OnDemand'
    /usr/bin/yum install -y amazon-efs-utils # Install EFS utils if you plan to use EFS
    EOF
}

# Explanation: Data source to get the latest EKS optimized AMI for worker nodes.
data "aws_ami" "eks_worker_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks_cluster.version}-v*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Explanation: Auto Scaling Group to manage the worker nodes.
resource "aws_autoscaling_group" "eks_worker_asg" {
  name                      = "${var.cluster_name}-worker-asg"
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  desired_capacity          = var.desired_nodes
  max_size                  = var.desired_nodes + 1 # Allow one extra for rolling updates
  min_size                  = 1
  launch_template {
    id      = aws_launch_template.eks_worker_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker"
    propagate_at_launch = true
  }
}

