# Proxmox source variables
packer {
  required_plugins {
  }
}

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "null" "proxmox" {
  ssh_host       = "${var.ssh_host}"
  ssh_username   = "${var.ssh_username}" # Default "root"
  ssh_agent_auth = true                  # Disable SSH agent auth when using private key file
  communicator   = "ssh"
}
