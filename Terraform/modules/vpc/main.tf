# Configuracion de red VPC
resource "aws_vpc" "vpc_eks" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "vpc_eks"
    username = var.username
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.vpc_eks.id
}
# Create the private subnet
resource "aws_subnet" "eks_private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.vpc_eks.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "private_subnets"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
    username = var.username
  }
}
# Create public subnet 
resource "aws_subnet" "eks_public_subnets" {
  count = 2
  vpc_id = aws_vpc.vpc_eks.id
  cidr_block = element(var.public_subnet_cidr_block, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet"
    username = var.username
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

# Create NAT for the private subnets
resource "aws_eip" "nat_eip" {
  count = length(aws_subnet.eks_private_subnets.*.id)
  domain = "vpc"
}



resource "aws_nat_gateway" "eks_nat" {
  count = length(aws_subnet.eks_public_subnets.*.id)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.eks_public_subnets.id

  tags = {
    Name = "eks-nat-gateway"
  }
}
# Create private route tables for each Availability Zone
resource "aws_route_table" "private_route_tables" {
  vpc_id = aws_vpc.vpc_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat[count.index].id
  }

  tags = {
    Name = "eks-private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(aws_subnet.eks_private_subnets)
  subnet_id      = aws_subnet.eks_private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

# Create the EKS control plane security group
resource "aws_security_group" "eks_control_plane_sg" {
  vpc_id = aws_vpc.vpc_eks.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-control-plane-sg"
  }
}

# Create the EKS worker nodes security group
resource "aws_security_group" "eks_worker_nodes_sg" {
  vpc_id = aws_vpc.vpc_eks.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-nodes-sg"
  }
}

# Add ingress rules to the EKS control plane security group
resource "aws_security_group_rule" "eks_control_plane_ingress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
}

# Add ingress rules to the EKS worker nodes security group
resource "aws_security_group_rule" "eks_worker_nodes_ingress_control_plane" {
  security_group_id        = aws_security_group.eks_worker_nodes_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
}

resource "aws_security_group_rule" "eks_worker_nodes_ingress_self" {
  security_group_id = aws_security_group.eks_worker_nodes_sg.id
  type              = "ingress"
  from_port         = 8285
  to_port           = 8285
  protocol          = "udp"
  self              = true
}

resource "aws_security_group_rule" "eks_control_plane_ingress_self" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 8285
  to_port           = 8285
  protocol          = "udp"
  self              = true
}

# Add ingress rules to the EKS control plane security group
resource "aws_security_group_rule" "eks_control_plane_ingress" {
  security_group_id = aws_security_group.eks_control_plane_sg.id
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
}

# Add ingress rules to the EKS worker nodes security group
resource "aws_security_group_rule" "eks_worker_nodes_ingress_control_plane" {
  security_group_id        = aws_security_group.eks_worker_nodes_sg.id
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
}


