resource "kubernetes_persistent_volume" "dali" {
  metadata {
    annotations = {"pv.kubernetes.io/provisioned-by": "file.csi.azure.com"}
    name = "dali"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "azurefile-csi"
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = var.kubernetes_storage_secret_name
        share_name  = var.dali_share_name
        secret_namespace = var.hpcc_aks_namespace
      }
    }
    mount_options = [ "dir_mode=0777", "file_mode=0777", "uid=10000", "gid=10001", "mfsymlinks", "cache=strict", "nosharesock", "nobrl"]
  }
  depends_on = [
    kubernetes_secret.hpcc-storage-auth
  ]
}

resource "kubernetes_persistent_volume" "data" {
  metadata {
    annotations = {"pv.kubernetes.io/provisioned-by": "file.csi.azure.com"}
    name = "data"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "azurefile-csi"
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = var.kubernetes_storage_secret_name
        share_name  = var.data_share_name
        secret_namespace = var.hpcc_aks_namespace
      }
    }
    mount_options = [ "dir_mode=0777", "file_mode=0777", "uid=10000", "gid=10001", "mfsymlinks", "cache=strict", "nosharesock", "nobrl"]
  }
  depends_on = [
    kubernetes_secret.hpcc-storage-auth
  ]
}

resource "kubernetes_persistent_volume" "dll" {
  metadata {
    annotations = {"pv.kubernetes.io/provisioned-by": "file.csi.azure.com"}
    name = "dll"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "azurefile-csi"
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = var.kubernetes_storage_secret_name
        share_name  = var.dll_share_name
        secret_namespace = var.hpcc_aks_namespace
      }
    }
    mount_options = [ "dir_mode=0777", "file_mode=0777", "uid=10000", "gid=10001", "mfsymlinks", "cache=strict", "nosharesock", "nobrl"]
  }
  depends_on = [
    kubernetes_secret.hpcc-storage-auth
  ]
}

resource "kubernetes_persistent_volume" "sasha" {
  metadata {
    annotations = {"pv.kubernetes.io/provisioned-by": "file.csi.azure.com"}
    name = "sasha"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "azurefile-csi"
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = var.kubernetes_storage_secret_name
        share_name  = var.sasha_share_name
        secret_namespace = var.hpcc_aks_namespace
      }
    }
    mount_options = [ "dir_mode=0777", "file_mode=0777", "uid=10000", "gid=10001", "mfsymlinks", "cache=strict", "nosharesock", "nobrl"]
  }
  depends_on = [
    kubernetes_secret.hpcc-storage-auth
  ]
}

resource "kubernetes_persistent_volume" "mydropzone" {
  metadata {
    annotations = {"pv.kubernetes.io/provisioned-by": "file.csi.azure.com"}
    name = "mydropzone"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "azurefile-csi"
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = var.kubernetes_storage_secret_name
        share_name  = var.mydropzone_share_name
        secret_namespace = var.hpcc_aks_namespace
      }
    }
    mount_options = [ "dir_mode=0777", "file_mode=0777", "uid=10000", "gid=10001", "mfsymlinks", "cache=strict", "nosharesock", "nobrl"]
  }
  depends_on = [
    kubernetes_secret.hpcc-storage-auth
  ]
}

