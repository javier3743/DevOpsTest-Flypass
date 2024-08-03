# Configuracion de red VPC
resource "aws_vpc" "vpc_eks" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "vpc_eks"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create the private subnet
resource "aws_subnet" "private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.vpc_eks.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)

  tags = {
    Name = "private_subnets"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Create IGW for the public subnets
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "internet_gw"
  }
}

# Route traffic through the IGW
resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.vpc_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "eks-route-table"
  }
}
resource "aws_route_table_association" "eks_route_table_association" {
  count = 3
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.eks_route_table.id
}