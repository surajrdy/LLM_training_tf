resource "nutanix_virtual_machine" "windows_2019_server2" {
  name                 = "Windows Server 2019 - Example 3 Server 2"
  cluster_uuid         = data.nutanix_cluster.nutanixjeddah.cluster_id
  num_vcpus_per_socket = 2
  num_sockets          = 4
  memory_size_mib      = 16384

  disk_list {
    #disk_size_mib and disk_size_bytes must be set together.
    disk_size_mib   = 100000
    disk_size_bytes = 104857600000
  }

  nic_list {
    subnet_uuid = var.Subnet_UUID
  }
}
