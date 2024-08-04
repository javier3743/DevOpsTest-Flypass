# Configuracion de red VPC
resource "aws_vpc" "vpc_eks" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "vpc_eks"
    username = var.username
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

resource "aws_vpc_dhcp_options" "main_eks" {
  domain_name          = format("%s.compute.internal", var.region)
  domain_name_servers  = ["AmazonProvidedDNS"]
  
  tags = {
    Name = "vpc_dhcp_eks"
    username = var.username
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.vpc_eks.id
  dhcp_options_id = aws_vpc_dhcp_options.main_eks.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    username = var.username
    name = "igw_eks"
  }
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
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create NAT for the private subnets
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat_eip"
    username = var.username
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_public_subnets[1].id

  tags = {
    Name = "gwNAT"
    username = var.username
  }
}
#### Creating Route Table For Public & Private

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "public_rt"
    username = var.username
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "private_rt"
    username = var.username
  }
}

#### Creating Routes For IGW & NAT

resource "aws_route" "igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

#### Creating Route Table Association For Public & Private Subnets

resource "aws_route_table_association" "public_rt" {
  count = length(aws_subnet.eks_public_subnets)
  subnet_id      = aws_subnet.eks_public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt" {
  count = length(aws_subnet.eks_private_subnets)
  subnet_id      = aws_subnet.eks_private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Create the EKS control plane security group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster_sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc_eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    username = var.username
  }
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  to_port                  = 443
  type                     = "ingress"
}

# Create the EKS workers security group
resource "aws_security_group" "eks_worker_cluster_sg" {
  name        = "eks_worker_cluster_sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.vpc_eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    username = var.username
  }
}

resource "aws_security_group_rule" "eks-worker-cluster-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker_cluster_sg.id
  cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-worker-cluster-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_cluster_sg.id
  cidr_blocks              = ["10.0.4.0/24", "10.0.5.0/24", "10.0.0.0/24", "10.0.1.0/24"]
  to_port                  = 65535
  type                     = "ingress"
}
