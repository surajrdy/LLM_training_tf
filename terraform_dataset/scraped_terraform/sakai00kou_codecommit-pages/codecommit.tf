#-----------------------------------------------------------------------------------------------------------------------
# ドキュメント格納用CodeCommitリポジトリ
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_codecommit_repository" "codecommit_pages" {
  repository_name = local.codecommit_repository
  description     = local.codecommit_repository
  default_branch  = local.codecommit_branch_name
}
