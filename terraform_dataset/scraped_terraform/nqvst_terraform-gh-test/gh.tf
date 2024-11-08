terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}


resource "github_repository" "terraform-gh-test" {
    name            = "terraform-gh-test"
    description     = "a test repo to learn terraform's github provider."

    visibility          = "public"
    has_wiki            = false
    has_issues          = false
    has_projects        = false
    gitignore_template  = "Node"

}

resource "github_repository_file" "hello_world_txt" {
    repository          = "terraform-gh-test"
    branch              = "main"
    file                = "hello_world.txt"
    content             = "Hello World!"
    commit_message      = "add hello world document"
    commit_author       = "nqvst_terraform"
    commit_email        = "terraform@enqvist.io"
}


resource "github_repository_file" "readme_md" {
    repository          = "terraform-gh-test"
    branch              = "main"
    file                = "readme.md"
    content             = file("${path.module}/readme.md")
    commit_message      = "add readme.md"
    commit_author       = "nqvst_terraform"
    commit_email        = "terraform@enqvist.io"
}

resource "github_repository_file" "gh_tf" {
    repository          = "terraform-gh-test"
    branch              = "main"
    file                = "gh.tf"
    content             = file("${path.module}/gh.tf")
    commit_message      = "add the terraform file"
    commit_author       = "nqvst_terraform"
    commit_email        = "terraform@enqvist.io"
}

