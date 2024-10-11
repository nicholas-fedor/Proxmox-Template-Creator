// source.pkr.hcl

// https://developer.hashicorp.com/packer/docs/builders/null
// Uses a null builder to setup an SSH connection with the Proxmox host
source "null" "proxmox" {
  ssh_host     = "${var.ssh_host}"
  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"
}