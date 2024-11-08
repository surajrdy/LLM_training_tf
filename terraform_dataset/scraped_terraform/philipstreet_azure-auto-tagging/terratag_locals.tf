locals {

  # Tags to be applied to all resources
  tags = {
    "Environment"  = title(var.environment)
    "DeployedFrom" = title(var.deployed_from)
    "Tagger"       = "Terratag"
  }
}
