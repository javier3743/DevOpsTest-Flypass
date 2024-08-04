# Crear un repositorio de imagenes en ECR
resource "aws_ecr_repository" "ecr_test_repo" {
  name                 = var.repository_name

  tags = {
    Name     = "ecr_test_repo"
    username = var.username
  }
}