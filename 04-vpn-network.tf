# Create vNET Networks
resource "openstack_networking_network_v2" "vpc_network" {
  name           = "VPC Network"
  description    = "Local Peering VPC Network" 
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "wan_network" {
  name           = "WAN Network"
  description    = "Transfer Net for binding FloatingIPs" 
  admin_state_up = "true"
}

# Create Subnets
resource "openstack_networking_subnet_v2" "vpc_subnet_1" {
  name       = "vpc_subnet"
  description = "Local VPC Network"
  network_id = openstack_networking_network_v2.vpc_network.id
  cidr       = var.LOCAL_SUBNET
  ip_version = 4
  dns_nameservers = [
    "208.67.222.222",
    "9.9.9.9",
  ]
}

resource "openstack_networking_subnet_v2" "wan_subnet_1" {
  name       = "wan_subnet"
  description = "WAN Network"
  network_id = openstack_networking_network_v2.wan_network.id
  cidr       = "100.96.96.0/25"
  ip_version = 4
  dns_nameservers = [
    "208.67.222.222",
    "9.9.9.9",
  ]
}

# Create Routers
resource "openstack_networking_router_v2" "vpc_router" {
  name                = "vpc_router"
  description         = "VPC Router" 
  external_network_id = "970ace5c-458f-484a-a660-0903bcfd91ad"
}

resource "openstack_networking_router_v2" "wan_router" {
  name                = "wan_router"
  description         = "WAN Router" 
  external_network_id = "970ace5c-458f-484a-a660-0903bcfd91ad"
}

# Create Router interfaces
resource "openstack_networking_router_interface_v2" "vpc_router_interface_1" {
  router_id = openstack_networking_router_v2.vpc_router.id
  subnet_id = openstack_networking_subnet_v2.vpc_subnet_1.id
}

resource "openstack_networking_router_interface_v2" "wan_router_interface_1" {
  router_id = openstack_networking_router_v2.wan_router.id
  subnet_id = openstack_networking_subnet_v2.wan_subnet_1.id
}

# Create static routing entry for VPN Traffic to hit the Appliance instead of the default gateway
resource "openstack_networking_router_route_v2" "vpc_router_route_1" {
  depends_on       = [openstack_networking_router_interface_v2.vpc_router_interface_1]
  router_id        = "${openstack_networking_router_v2.vpc_router.id}"
  destination_cidr = "${var.REMOTE_SUBNET}"
  next_hop         = "${openstack_compute_instance_v2.instance_vpn.network.1.fixed_ip_v4}"
}