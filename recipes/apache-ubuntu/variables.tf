variable prefix {
    description = "prefix of the resource"
    default = "newvm"
}
variable floating_ip_pool {
    description = "Name of the floating IP pool"
    default = "Public External IPv4 Network"
}
variable ssh_user {
    description = "SSH user name (use the default user for the OS image)"
    default     = "ubuntu"
}
variable private_ssh_key {
    description = "Local path to the private SSH key"
    default =  "./private/webap.key"
}
variable public_ssh_key {
    description = "Local path to the public SSH key"
    default =  "./private/webap.key.pub"
}
variable external_network_id {
    description = "ID for the external network"
}
variable image_name {
    description = "Name of the image for the instance"
    default =  "Ubuntu 18.04 LTS (Bionic Beaver) - latest"
}
variable flavor_name {
    description = "Name of the image for the instance"
    default =  "ssc.large"
}
variable size_volume {
    description = "size of the volume to be attached to the instance"
    default = 100
}
