output "vpc_id" {
  value = aws_vpc.vpc_eks.id
}

output "subnet_ids" {
  value = aws_subnet.eks_public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.eks_private_subnets[*].id
}

output "eks_cluster_sg" {
  value= aws_security_group.eks_cluster_sg.id
}

output "eks_nodes_sg" {
  value = aws_security_group.eks_worker_sg.id
}