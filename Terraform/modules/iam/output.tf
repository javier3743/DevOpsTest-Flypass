output "cluster_role_arn" {
  value = aws_iam_role.cluster_iam_role.arn
}
output "nodes_role_arn" {
  value = aws_iam_role.nodes_iam_role.arn
}