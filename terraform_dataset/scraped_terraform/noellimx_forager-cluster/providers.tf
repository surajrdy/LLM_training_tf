# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.2"
    }
  }
  required_version = ">= 0.14"
}


provider "google" {
  project = var.project_id
  region  = var.region
}
