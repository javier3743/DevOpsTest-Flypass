# Se crea rol para cluster
resource "aws_iam_role" "cluster_iam_role" {
  name= "cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name     = "cluster-role"
    username = var.username
  }
}

# Se crea rol para los nodos
resource "aws_iam_role" "nodes_iam_role" {
  name     = "nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  
  tags = {
    Name     = "nodes-role"
    username = var.username
  }
}

# Se añaden las politicas a cada rol

resource "aws_iam_role_policy_attachment" "cluster_iam_policy" {
  for_each = toset(var.cluster_roles)

  policy_arn = each.value
  role       = "cluster-role"
  depends_on = [aws_iam_role.cluster_iam_role]
  
}

resource "aws_iam_role_policy_attachment" "nodes_iam_policy" {
  for_each = toset(var.nodes_roles)

  policy_arn = each.value
  role       = "nodes-role"

  depends_on = [aws_iam_role.nodes_iam_role]
}