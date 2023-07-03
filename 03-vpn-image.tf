# Upload VPN Appliance Image to OpenStack
resource "openstack_images_image_v2" "vpn_appliance_image" {
  name             = "vpn_appliane-${var.VERSION}-${var.STAGE}"
  image_source_url = "https://vpn-appliance.object.storage.eu01.onstackit.cloud/vpn-appliance-${var.VERSION}-${var.STAGE}.qcow2"
  web_download     = true
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "shared"
}