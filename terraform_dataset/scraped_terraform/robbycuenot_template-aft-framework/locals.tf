locals {
  tfc_workspace_slug_split = split("/", var.TFC_WORKSPACE_SLUG)
  tfc_current_organization_name    = local.tfc_workspace_slug_split[0]
  tfc_current_workspace_name       = local.tfc_workspace_slug_split[1]

  github_identifier = data.tfe_workspace.current_workspace.vcs_repo["0"].identifier
  github_identifier_split = split("/", local.github_identifier)
  github_owner = local.github_identifier_split[0]
  
  aft_session_name = "AWSAFT-Session"
}
