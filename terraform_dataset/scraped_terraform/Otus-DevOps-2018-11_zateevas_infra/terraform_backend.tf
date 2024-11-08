data "terraform_remote_state" "rs" {
  backend = "gcs"

  config {
    bucket = "zateevas-storage-bucket-test"
    prefix = "hashicorp/rs-prod"
  }
}
