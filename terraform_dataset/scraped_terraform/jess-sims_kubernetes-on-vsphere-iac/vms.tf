# Create a VM from a template
resource "vsphere_virtual_machine" "vm_leader"{
  name = var.vm_name_leader
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id =  data.vsphere_datastore.datastore.id
 # datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_system_id       = data.vsphere_host.host.id
  # resource_pool_id     = data.vsphere_resource_pool.default.id


  wait_for_guest_net_timeout = 0

  num_cpus = var.vm_cpus
  memory = var.vm_memory
  guest_id = var.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }
  

  disk {
    label = "disk0"
    thin_provisioned = true
    size = 50
  }

  cdrom {
    client_device = true
  }

   clone {
     template_uuid = data.vsphere_content_library_item.content_library_item.id
   }

  # ovf_deploy {
  #  allow_unverified_ssl_cert = false
  #  remote_ovf_url            = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.ova"
  #  disk_provisioning         = "thin"
  #  ip_protocol               = "IPV4"
  #  ip_allocation_policy      = "DHCP_POLICY"
  #  ovf_network_map = {
  #    "Network 1" = data.vsphere_network.network.id
  #  }
  # }

  vapp {
    properties ={
      hostname = var.vm_name_leader
      user-data = base64encode(file("${path.module}/cloudinit/kickstart.yaml"))
    }
  }

  extra_config = {
    "guestinfo.metadata"          = base64encode(file("${path.module}/cloudinit/metadata.yaml"))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(file("${path.module}/cloudinit/userdata.yaml"))
    "guestinfo.userdata.encoding" = "base64"
  }

}


 # Create a VM from a template
 resource "vsphere_virtual_machine" "vm_worker" {
   count = var.worker-count
   name = "${var.vm-prefix}-worker-${count.index + 1}"
   resource_pool_id = data.vsphere_resource_pool.pool.id
   datastore_id =  data.vsphere_datastore.datastore.id
 #  datacenter_id        = data.vsphere_datacenter.datacenter.id
   host_system_id       = data.vsphere_host.host.id

   wait_for_guest_net_timeout = 0
   depends_on = [ vsphere_virtual_machine.vm_leader ]
   num_cpus = var.vm_cpus
   memory = var.vm_memory
   guest_id = var.guest_id
   
  network_interface {
     network_id = data.vsphere_network.network.id
     adapter_type = "vmxnet3"
   }
  

   disk {
     label = "${var.vm-prefix}-${count.index + 1}-disk"
     thin_provisioned = true
     size = 50
   }

  cdrom {
    client_device = true
  }

   # cdrom {
   #   datastore_id = data.vsphere_datastore.datastore.id
   #   path = "ubuntu-22.04.2-desktop-amd64.iso"
   # }

   clone {
     template_uuid = data.vsphere_content_library_item.content_library_item.id
   }

#  ovf_deploy {
#    allow_unverified_ssl_cert = false
#    remote_ovf_url            = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.ova"
#    disk_provisioning         = "thin"
#    ip_protocol               = "IPV4"
#    ip_allocation_policy      = "DHCP_POLICY"
#    ovf_network_map = {
#      "Network 1" = data.vsphere_network.network.id
#    }
#  }
   vapp {
     properties ={
       hostname = "${var.vm-prefix}-worker-${count.index + 1}"
       user-data = base64encode(file("${path.module}/cloudinit/kickstart.yaml"))
     }
   }

  extra_config = {
     "guestinfo.metadata"          = base64encode(file("${path.module}/cloudinit/metadata.yaml"))
     "guestinfo.metadata.encoding" = "base64"
     "guestinfo.userdata"          = base64encode(file("${path.module}/cloudinit/userdata.yaml"))
     "guestinfo.userdata1"          = templatefile("${path.module}/cloudinit/userdata.yaml", { hostname = "${var.vm-prefix}-worker-${count.index + 1}" })
     "guestinfo.userdata.encoding" = "base64"
   }
#
# output "control_ip_addresses" {
#  value = vsphere_virtual_machine.control.*.default_ip_address
# }

# output "worker_ip_addresses" {
#  value = vsphere_virtual_machine.worker.*.default_ip_address
 }

# }