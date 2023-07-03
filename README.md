# STACKIT VPN Appliance Terraform Deployment
Included here are the deployment scripts for Terraform.

![](overview.svg)

For the network setup two VPC networks are created `vpc_network` and `wan_network` the subnet of the VPC network can be set freely. For the WAN network the network range `100.96.96.0/25` is preset. However, there should be no collisions here, since this network is only used for incoming connections to the VPN appliance.
For each of the two networks, additional routers are created. On the one hand, these routers establish a NAT Internet connection and on the other hand, they are used to bind floating IPs and to route the remote VPN networks to the VPN appliance.

In the folder itself, the file `.env` must be created with the content shown below.

Configuration options:
```console
export TF_VAR_USERNAME=<OpenStack Username>
export TF_VAR_PASSWORD=<OpenStack Password>
export TF_VAR_TENANTID=<OpenStack Project ID>
export TF_VAR_VERSION=<VPN Appliance Version>
export TF_VAR_STAGE=<(Optional) Default Prod>
export TF_VAR_REMOTE_SUBNET="<Remote Subnetwork>"
export TF_VAR_LOCAL_SUBNET="<(Optional) Default 10.0.0.0/24>"
export TF_VAR_SSH_KEY=<Public SSH Key String>
```

The versions can be found in the image repository:
https://vpn-appliance.object.storage.eu01.onstackit.cloud/index.html

By specifying the `LOCAL` and `REMOTE` network, the routes for the network range are entered in OpenStack.
If several networks are to be routed, this can be adjusted on the one hand via a sum route or via further manual entries on the OpenStack router.

In addition to the settings in the `.env` file, further settings can also be made in `deployment.sh`.
Here the certificate based authentication can be deactivated. Furthermore it is also possible to include own scripts.
Please note that the scripts or commands must not have any external dependencies, because only the `deployment.sh` is transferred to the server.

Further settings can be made in the `01-config.tf`.
Settings such as ACL for the connection via SSH or IPsec can be made here,
the selection of the Availability Zone or the VM size (flavor) can be determined.

### Setup:

1. Load Config:
    ```bash
    source .env
    ```
1. Launch Terrafrom
    ```bash
    terraform apply
    ```