resource "aws_iam_group_policy_attachment" "business_owner" {
  group      = aws_iam_group.budget_owner.name
  policy_arn = aws_iam_policy.business_owner.arn
}

resource "aws_iam_group_policy_attachment" "budget_owner" {
  group      = aws_iam_group.budget_owner.name
  policy_arn = aws_iam_policy.budget_owner.arn
}

resource "aws_iam_group_policy_attachment" "front_end_developer" {
  group      = aws_iam_group.front_end_developer.name
  policy_arn = aws_iam_policy.frontend_developer.arn
}

resource "aws_iam_group_policy_attachment" "backend_developer" {
  group      = aws_iam_group.backend_developer.name
  policy_arn = aws_iam_policy.backend_developer.arn
}

resource "aws_iam_group_policy_attachment" "oso_devops_engineer" {
  group      = aws_iam_group.oso_devops_engineer.name
  policy_arn = aws_iam_policy.oso_devops_engineer.arn
}

resource "aws_iam_group_policy_attachment" "oso_devops_support" {
  group      = aws_iam_group.oso_devops_support.name
  policy_arn = aws_iam_policy.oso_devops_support.arn
}

resource "aws_iam_group_policy_attachment" "enforce_mfa" {
  group      = aws_iam_group.enforce_mfa.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}