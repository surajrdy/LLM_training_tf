# primary ipv6
resource "oci_core_ipv6" "IPv6-1-A" {
  vnic_id = data.oci_core_private_ips.Private-IP-1.private_ips[0].vnic_id
}
data "oci_core_private_ips" "Private-IP-1" {
  ip_address = oci_core_instance.Instance-1.private_ip
  subnet_id  = oci_core_subnet.Subnet-default.id
}

# static address
resource "oci_core_vnic_attachment" "VNIC-Instance-1" {
  instance_id = oci_core_instance.Instance-1.id
  create_vnic_details {
    subnet_id = oci_core_subnet.Subnet-default.id
  }
}
resource "oci_core_ipv6" "IPv6-1-static" {
  vnic_id = oci_core_vnic_attachment.VNIC-Instance-1.vnic_id
}
resource "oci_core_public_ip" "Public-IP-1-B" {
  compartment_id = var.tenancy_ocid
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.VNIC-Instance-1-IP.private_ips[0].id
  lifecycle {
    prevent_destroy = true
  }
}
data "oci_core_private_ips" "VNIC-Instance-1-IP" {
  vnic_id = oci_core_vnic_attachment.VNIC-Instance-1.vnic_id
}

# extraneous NICs
resource "oci_core_vnic_attachment" "VNIC-Instance-1-extra" {
  count       = 1
  instance_id = oci_core_instance.Instance-1.id
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.Subnet-default.id
  }
}
resource "oci_core_ipv6" "IPv6-1-extra" {
  count   = 1
  vnic_id = oci_core_vnic_attachment.VNIC-Instance-1-extra[count.index].vnic_id
}


data "oci_core_private_ips" "Private-IP-2" {
  ip_address = oci_core_instance.Instance-2.private_ip
  subnet_id  = oci_core_subnet.Subnet-default.id
}
resource "oci_core_ipv6" "IPv6-2" {
  vnic_id = data.oci_core_private_ips.Private-IP-2.private_ips[0].vnic_id
}
