output "role_arn" {
  value = aws_iam_role.role.arn
  description = "The ARN of the created cross account role."
}
