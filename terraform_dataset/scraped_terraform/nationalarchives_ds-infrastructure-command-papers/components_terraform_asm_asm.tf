resource "aws_secretsmanager_secret" "cognito" {
    name        = "application/command-papers/cognito"
    description = "CommandPapers web - Cognito credentials"

    tags = merge( var.tags, {
        Name = "command-papers/cognito"
    })
}

resource "aws_secretsmanager_secret_version" "cognito_user_pool_details" {
    secret_id     = aws_secretsmanager_secret.cognito.id
    secret_string = "{\"UserPoolId\":\"${var.cognito_user_pool_id}\",\"ClientId\":\"${var.cognito_client_pool_id}\",\"ClientSecret\":\"${var.cognito_user_pool_client_secret}\"}"
}
