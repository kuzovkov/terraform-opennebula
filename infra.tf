variable "one_endpoint" {}
variable "one_username" {}
variable "one_password" {}
variable "one_flow_endpoint" {}

provider "opennebula" {
  endpoint      = "${var.one_endpoint}"
  flow_endpoint = "${var.one_flow_endpoint}"
  username      = "${var.one_username}"
  password      = "${var.one_password}"
}


terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "0.4.3"
    }
  }
}

data "opennebula_group" "users" {
  count = 2
  name = "users-${count.index+1}"
}

resource "opennebula_virtual_network" "priv-net" {
  count = 2
  name = "net-${count.index+1}"
  bridge = "net-${count.index+1}"
  physical_device = "eth0"
  group = data.opennebula_group.users[count.index].name
  network_mask = "255.255.255.0"
  gateway = "172.16.0.1"
  type = "vxlan"
  automatic_vlan_id = true
  ar {
    ar_type = "IP4"
    size = 254
    ip4 = "172.16.0.1"
  }
   permissions = "640"
}

data "opennebula_template" "nat" {
  name = "Service VNF"
}

data "opennebula_virtual_network" "public" {
  name = "public"
}

data "opennebula_virtual_network" "private" {
  count = 2
  name = "net-${count.index+1}"
}

resource "opennebula_virtual_machine" "nat" {
  count = 2
  name = "nat ${count.index+1}"
  template_id = data.opennebula_template.nat.id
  permissions = "640"
  group = data.opennebula_group.users[count.index].name
  nic {
    model = "virtio"
    network_id = data.opennebula_virtual_network.public.id
  }

  nic {
    model = "virtio"
    network_id = data.opennebula_virtual_network.private[count.index].id
    ip = "172.16.0.1"
  }

  context = {
    ONEAPP_VNF_NAT4_ENABLED = "YES"
    ONEAPP_VNF_NAT4_INTERFACES_OUT = "eth0"
    ONEAPP_VNF_ROUTER4_ENABLED = "YES"
  }
}

data "opennebula_template" "ubuntu" {
  name = "Ubuntu 18.04"
}

resource "opennebula_virtual_machine" "srv" {
  count = 2
  name = "srv-ubuntu-${count.index+1}"
  template_id = data.opennebula_template.ubuntu.id
  permissions = "660"
  group = data.opennebula_group.users[count.index].name

  nic {
    model = "virtio"
    network_id = data.opennebula_virtual_network.private[count.index].id
    ip = "172.16.0.2"
  }

  context = {
    SET_HOSTNAME = "$NAME"
    PASSWORD = "rootroot"
    DNS = "8.8.8.8"
  }


}

resource "opennebula_virtual_machine" "cli" {
  count = 2
  name = "cli-ubuntu-${count.index+1}"
  template_id = data.opennebula_template.ubuntu.id
  permissions = "640"
  group = data.opennebula_group.users[count.index].name

  nic {
    model = "virtio"
    network_id = data.opennebula_virtual_network.private[count.index].id
    ip = "172.16.0.3"
  }

  context = {
    SET_HOSTNAME = "$NAME"
    PASSWORD = "rootroot"
    DNS = "8.8.8.8"
  }
}







