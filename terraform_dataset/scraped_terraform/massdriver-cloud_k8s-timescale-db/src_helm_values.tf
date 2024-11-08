locals {
  helm_values = {
    serviceAccount = {
      name = var.md_metadata.name_prefix
    }
    image = {
      # We want to control when the pgsql or timescale versions are updated as this may require additional action in this bundle.
      # As a Terraform variable, we can also refer to it in the artifact specs.
      # Image
      # https://github.com/timescale/timescaledb-docker-ha
      tag = "pg14.5-ts2.8.1-p2"
    }

    resources = {
      requests = {
        cpu    = tostring(var.database_configuration.cpu_limit)
        memory = "${var.database_configuration.memory_limit}Gi"
      }
      limits = {
        cpu    = tostring(var.database_configuration.cpu_limit)
        memory = "${var.database_configuration.memory_limit}Gi"
      }
    }

    persistentVolumes = {
      data = {
        size = "${var.database_configuration.data_volume_size}Gi"
      }
    }

    service = {
      primary = {
        labels = var.md_metadata.default_tags
      }
      replica = {
        labels = var.md_metadata.default_tags
      }
    }

    secrets = {
      credentials = {
        PATRONI_SUPERUSER_PASSWORD = local.user_super.password
      }
    }

    patroni = {
      postgresql = {
        authentication = {
          superuser = {
            username = local.user_super.username
            password = local.user_super.password
          }
        }
      }
    }
  }
}
