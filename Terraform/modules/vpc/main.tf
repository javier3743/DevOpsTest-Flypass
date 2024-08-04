# Configuracion de red VPC
resource "aws_vpc" "vpc_eks" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "vpc_eks"
    username = var.username
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create the private subnet
resource "aws_subnet" "private_subnets" {
  count             = 3
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
# Create public subnet for access form private subnets to internet
resource "aws_subnet" "eks_public_subnet" {
  vpc_id = aws_vpc.vpc_eks.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet"
    username = var.username
  }
}

# Create nat for the public subnets
resource "aws_eip" "nat_eip" {
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.vpc_eks.id
}

resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_public_subnet.id

  tags = {
    Name = "eks-nat-gateway"
  }
}

resource "aws_route_table" "eks_private_route_table" {
  vpc_id = aws_vpc.vpc_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }

  tags = {
    Name = "eks-private-route-table"
  }
}

resource "aws_route_table_association" "eks_private_route_table_association" {
  count = 3
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.eks_private_route_table.id
}
