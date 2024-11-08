terraform {
  backend "remote" {
    organization = "popa-org"

    workspaces {
      prefix = "workspace-run-"
    }
  }
}