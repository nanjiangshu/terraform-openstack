resource "openstack_compute_keypair_v2" "sshkey" {
  name       = "${var.prefix}-sshkey"
  public_key =  file(var.public_ssh_key)

}

resource "openstack_networking_network_v2" "network" {
  name           = "${var.prefix}-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnetwork" {
  name       = "${var.prefix}-subnet"
  network_id = openstack_networking_network_v2.network.id
  cidr       = "10.0.0.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
  enable_dhcp = "true"
}

resource "openstack_networking_router_v2" "r_router" {
  name                =  "${var.prefix}-router"
  admin_state_up      = "true"
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "r_router_interface" {
  router_id = openstack_networking_router_v2.r_router.id
  subnet_id = openstack_networking_subnet_v2.subnetwork.id
}



resource "openstack_compute_secgroup_v2" "r_secgroup" {
  name        =  "${var.prefix}-secgroup"
  description = "security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 8080
    to_port     = 8080
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 8888
    to_port     = 8888
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_port_v2" "r_port" {
  name               =  "${var.prefix}-port"
  network_id         = openstack_networking_network_v2.network.id
  admin_state_up     = "true"
  security_group_ids = [openstack_compute_secgroup_v2.r_secgroup.id]

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnetwork.id
    ip_address = "10.0.0.10"
  }
}

resource "openstack_networking_floatingip_v2" "r_ip" {
  pool = var.floating_ip_pool
}

resource "openstack_blockstorage_volume_v2" "r_vol" {
  name =  "${var.prefix}-vol"
  size = var.size_volume
}




resource "openstack_compute_instance_v2" "r_instance" {
  depends_on = [openstack_networking_subnet_v2.subnetwork]
  name            = var.prefix
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.sshkey.id
  security_groups = [openstack_compute_secgroup_v2.r_secgroup.id ]

  network {
    name = openstack_networking_network_v2.network.name
  }

}

resource "openstack_compute_volume_attach_v2" "volume_attachement_1" {
  instance_id = openstack_compute_instance_v2.r_instance.id
  volume_id   = openstack_blockstorage_volume_v2.r_vol.id
}


resource "openstack_compute_floatingip_associate_v2" "r_ip" {
  floating_ip = openstack_networking_floatingip_v2.r_ip.address
  instance_id = openstack_compute_instance_v2.r_instance.id
  fixed_ip    = openstack_compute_instance_v2.r_instance.network[0].fixed_ip_v4
}

resource "null_resource" "provision" {
  depends_on = [openstack_compute_floatingip_associate_v2.r_ip]
  connection {
    type = "ssh"
    user = var.ssh_user
    private_key = file(var.private_ssh_key)
    agent  = "true"
    timeout  = "5m"
    host = openstack_networking_floatingip_v2.r_ip.address
  }

  provisioner "file" {
    source      = "authorized-keys"
    destination = "/home/ubuntu"
  }
  provisioner "file" {
    source      = "src"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/src/add-sshkeys.sh",
      "bash /home/ubuntu/src/mount_volume.sh",
      "bash /home/ubuntu/src/install_apache.sh",
      "bash /home/ubuntu/src/install_docker.sh",
      "bash /home/ubuntu/src/install_singularity.sh",
    ]
  }
}


