resource "aws_iam_role_policy" "codecommit_gitpull" {
  name   = "codecommit_gitpull"
  count  = var.codecommit_gitpull && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.codecommit_gitpull[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "codecommit_gitpull" {
  count = var.codecommit_gitpull && var.enabled ? 1 : 0

  statement {
    actions   = ["codecommit:GitPull"]
    effect    = "Allow"
    resources = formatlist("arn:aws:codecommit:*:*:%v", var.codecommit_gitpull_repos)
  }
}

resource "aws_iam_role_policy" "codecommit_gitpush" {
  name   = "codecommit_gitpush"
  count  = var.codecommit_gitpush && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.codecommit_gitpush[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "codecommit_gitpush" {
  count = var.codecommit_gitpush && var.enabled ? 1 : 0

  statement {
    actions   = ["codecommit:GitPush"]
    effect    = "Allow"
    resources = formatlist("arn:aws:codecommit:*:*:%v", var.codecommit_gitpush_repos)
  }
}
