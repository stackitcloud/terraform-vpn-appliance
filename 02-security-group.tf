# Create IPsec Security Group
resource "openstack_networking_secgroup_v2" "IPsec" {
  name        = "IPsec"
  description = "Allow needed Connections"
}

# Add SSH Access Rule
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh["cidr"]
  security_group_id = "${openstack_networking_secgroup_v2.IPsec.id}"
}

# Add HTTPS Access Rule
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.ssh["cidr"]
  security_group_id = "${openstack_networking_secgroup_v2.IPsec.id}"
}

# Add IPSec Access Rule
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ipsec1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4500
  port_range_max    = 4500
  remote_ip_prefix  = var.any["cidr"]
  security_group_id = "${openstack_networking_secgroup_v2.IPsec.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ipsec2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 500
  port_range_max    = 500
  remote_ip_prefix  = var.any["cidr"]
  security_group_id = "${openstack_networking_secgroup_v2.IPsec.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ipsec_esp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "esp"
  remote_ip_prefix  = var.any["cidr"]
  security_group_id = "${openstack_networking_secgroup_v2.IPsec.id}"
}