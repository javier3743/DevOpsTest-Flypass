output "cluster-role" {
  value = cluster_iam_role.name
}

output "nodes-role" {
  value = nodes_iam_role.name
}