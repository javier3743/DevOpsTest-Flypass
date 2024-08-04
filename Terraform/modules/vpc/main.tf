resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_main"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = local.zone1

  tags = {
    "Name"                                                 = "${local.env}-private-${local.zone1}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = local.zone2

  tags = {
    "Name"                                                 = "${local.env}-private-${local.zone2}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = local.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                 = "${local.env}-public-${local.zone1}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = local.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                 = "${local.env}-public-${local.zone2}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.env}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "${local.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.env}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.env}-public"
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}
# # Configuracion de red VPC
# resource "aws_vpc" "vpc_eks" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_hostnames = true
#   tags = {
#     Name = "vpc_eks"
#     username = var.username
#     "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
#   }
# }
# resource "aws_internet_gateway" "eks_igw" {
#   vpc_id = aws_vpc.vpc_eks.id
# }
# # # Create the private subnet
# # resource "aws_subnet" "private_subnets" {
# #   count             = 3
# #   vpc_id            = aws_vpc.vpc_eks.id
# #   cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
# #   availability_zone = element(data.aws_availability_zones.available.names, count.index)

# #   tags = {
# #     Name = "private_subnets"
# #     "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
# #     "kubernetes.io/role/internal-elb" = 1
# #     username = var.username
# #   }
# # }
# # Create public subnet for access form private subnets to internet
# resource "aws_subnet" "eks_public_subnet" {
#   count = 2
#   vpc_id = aws_vpc.vpc_eks.id
#   cidr_block = element(var.public_subnet_cidr_block, count.index)
#   availability_zone = element(data.aws_availability_zones.available.names, count.index)
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "eks-public-subnet"
#     username = var.username
#   }
# }

# # Create nat for the public subnets
# # resource "aws_eip" "nat_eip" {
# # }



# # resource "aws_nat_gateway" "eks_nat" {
# #   allocation_id = aws_eip.nat_eip.id
# #   subnet_id     = aws_subnet.eks_public_subnet.id

# #   tags = {
# #     Name = "eks-nat-gateway"
# #   }
# # }

# resource "aws_route_table" "eks_private_route_table" {
#   vpc_id = aws_vpc.vpc_eks.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.eks_igw.id
#   }

#   tags = {
#     Name = "eks-private-route-table"
#   }
# }

# resource "aws_route_table_association" "eks_private_route_table_association" {
#   count = 2
#   subnet_id = element(aws_subnet.eks_public_subnet.*.id, count.index)
#   route_table_id = aws_route_table.eks_private_route_table.id
# }

# resource "aws_security_group" "eks_control_plane_sg" {
#   vpc_id = aws_vpc.vpc_eks.id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere, adjust as needed
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
