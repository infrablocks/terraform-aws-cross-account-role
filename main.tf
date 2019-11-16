data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    principals {
      identifiers = var.assumable_by_account_ids
      type = "AWS"
    }

    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "role" {
  role = aws_iam_role.role.name
  policy_arn = var.policy_arn
}
