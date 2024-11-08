
///////////////// kringlab02 host ///////////////////

provider "libvirt" {
  uri = "qemu+ssh://10.0.0.20/system"
  alias = "kringlab02"
}

# Base OS image to use to create a cluster of different nodes
resource "libvirt_volume" "base_02" {
  provider = libvirt.kringlab02
  name   = "base_image_fcos.qcow2"
  source = var.base_image
}

resource "libvirt_volume" "qcow_volume_02" {
  for_each = { for index, vm in var.virtual_machines : 
              vm.name => vm if vm.host == "kringlab02" }
  provider = libvirt.kringlab02
  name = "${each.value.name}.img"
  pool = "default"
  base_volume_id = libvirt_volume.base_02.id
  size = 20 * 1024 * 1024 * 1024 # 20GiB. the root FS is automatically resized by cloud-init growpart (see https://cloudinit.readthedocs.io/en/latest/topics/examples.html#grow-partitions).

}

resource "libvirt_ignition" "ignition_02" {
  provider = libvirt.kringlab02
  for_each = { for index, vm in var.virtual_machines : 
              vm.name => vm if vm.host == "kringlab02" }
  name           = "${each.value.name}-ignition.iso"
  content = data.ignition_config.ignition[each.key].rendered
}

# Define KVM domain to create
resource "libvirt_domain" "kvm_domain_02" {
  provider = libvirt.kringlab02
  for_each = { for index, vm in var.virtual_machines : 
              vm.name => vm if vm.host == "kringlab02" }
  name   = each.value.name
  memory = each.value.memory
  vcpu   = each.value.cpu
  autostart = true

  coreos_ignition = libvirt_ignition.ignition_02[each.key].id

  disk {
    volume_id = libvirt_volume.qcow_volume_02[each.key].id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  network_interface {
    mac            = each.value.mac
    macvtap        = each.value.bridge
    wait_for_lease = false
  }
}
