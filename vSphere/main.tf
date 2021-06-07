provider "vsphere" {
    user           = "*User*"
    password       = "*MySecretP@$$0rd!!*"
    vsphere_server = "vCenterIP/FQDN"

    # If you have a self-signed cert
    allow_unverified_ssl = true
}
variable "datacenter" {
    default = "Datacenter"
}

variable "cluster" {
    default = "SCO-LABO"
}

data "vsphere_datacenter" "dc" {
    name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "compute_cluster" {
    name          = "${var.cluster}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_datastore" "datastore" {
    name          = "FREENAS1_VOL2"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "resource_pool" {
    name           = "vSphereLab-${random_string.random.result}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_resource_pool" "resource_pool" {
  name                    = "vSphereLab-${random_string.random.result}"
  parent_resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}"
}

data "vsphere_network" "network" {
    name          = "VM Network"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "host" {
    name          = "OneHostESXI"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "random_string" "random" {
  length           = 5
  special          = true
}

resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
    name = "Nested-ESXi-7.0"
    resource_pool_id = "${data.vsphere_resource_pool.resource_pool.id}"
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
    host_system_id = "${data.vsphere_host.host.id}"

    memory   = 8192
    wait_for_guest_net_timeout = 0
    wait_for_guest_ip_timeout = 0
     network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
   network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

    ovf_deploy {
         local_ovf_path = "/Storage/VMware/Nested_ESXi7.0u2a_Appliance_Template_v1.ova"
        disk_provisioning = "thin"
        ovf_network_map = {
            "VM Network" = "${data.vsphere_network.network.id}"
        }
    }

    vapp {
    properties = {
        "guestinfo.hostname" = "tf-nested-esxi-1.VMware.lab",
        "guestinfo.ipaddress" = "192.168.30.180",
        "guestinfo.netmask" = "255.255.255.0",
        "guestinfo.gateway" = "192.168.30.1",
        "guestinfo.dns" = "192.168.30.1",
        "guestinfo.domain" = "VMware.lab",
        "guestinfo.ntp" = "pool.ntp.org",
        "guestinfo.password" = "VMware1!",
        "guestinfo.ssh" = "True"
        }
    }
}

