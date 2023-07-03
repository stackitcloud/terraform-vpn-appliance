# Add SSH access key
resource "openstack_compute_keypair_v2" "vpn_key" {
  name       = "VPN Appliance SSH Key"
  public_key = var.SSH_KEY
}

# Create root Volume
resource "openstack_blockstorage_volume_v3" "vpn_root_volume" {
  name = "vpn_appliance-${var.VERSION}-${var.STAGE}"
  description = "Root Volume"
  size = 32
  image_id = openstack_images_image_v2.vpn_appliance_image.id
  availability_zone = var.zone
  volume_type = "storage_premium_perf4"
}

# Create virtual Server
resource "openstack_compute_instance_v2" "instance_vpn" {
  name = "VPN Appliance" # Server name
  flavor_name = var.flavor
  availability_zone = var.zone
  user_data = data.local_file.vpn_user_data.content
  key_pair    = openstack_compute_keypair_v2.vpn_key.name
  security_groups = ["default", "${openstack_networking_secgroup_v2.IPsec.id}"]

  block_device {
    uuid = openstack_blockstorage_volume_v3.vpn_root_volume.id
    source_type = "volume"
    destination_type = "volume"
    boot_index = 0
    delete_on_termination = true
  }

  network {
    name = "${openstack_networking_network_v2.wan_network.name}"
  }

  network {
    port = "${openstack_networking_port_v2.vpn_port_2.id}"
  }

}

# Network Ports
resource "openstack_networking_port_v2" "vpn_port_2" {
  name           = "VPN VPC Port"
  network_id     = openstack_networking_network_v2.vpc_network.id
  admin_state_up = "true"
  port_security_enabled = "false"
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.vpc_subnet_1.id
  }
}


# Add FloatingIP
resource "openstack_networking_floatingip_v2" "fip" {
  pool = "floating-net"
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.instance_vpn.id
  fixed_ip = openstack_compute_instance_v2.instance_vpn.network.0.fixed_ip_v4
}