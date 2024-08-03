resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags = {
    Name     = "s3_bucket"
    username = var.username
  }
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "10.0.0.0/16"
          }
        }
      }
    ]
  })
}