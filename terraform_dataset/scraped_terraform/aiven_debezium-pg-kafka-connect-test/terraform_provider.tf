terraform {
  required_providers {
    aiven = {
      source = "aiven/aiven"
      version = "2.1.19"
    }
  }
}

# Initialize provider. No other config options than api_token
provider "aiven" {
  api_token = var.avn_api_token
}
