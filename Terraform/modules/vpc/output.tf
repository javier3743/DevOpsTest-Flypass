output "vpc_id" {
  value = aws_vpc.vpc_eks.id
}

output "subnet_ids" {
  value = aws_subnet.eks_public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.eks_private_subnets[*].id
}