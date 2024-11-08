resource "oci_core_volume" "volume_100" {
    #Required
    compartment_id = var.COMPARTMENT_OCID

    #Optional
    availability_domain = "okdB:EU-FRANKFURT-1-AD-2"
    display_name = "volume_100GB"
    size_in_gbs = 100
}


resource "oci_core_volume_attachment" "test_volume_attachment" {
    #Required
    attachment_type = "paravirtualized"
    instance_id = oci_core_instance.apollo.id
    volume_id = oci_core_volume.volume_100.id
}
