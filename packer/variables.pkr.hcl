# Variable Definitions
# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/variables

# source.pkr.hcl
# proxmox-host.auto.pkrvars.hcl
variable "ssh_host" {
  type        = string
  description = "Proxmox IP/FQDN, i.e. 192.168.1.2 or pve.example.com"
  default     = null
}

variable "ssh_username" {
  type        = string
  description = "Proxmox username"
  default     = "root"
}

# build.pkr.hcl
# proxmox-host.auto.pkrvars.hcl

# OS Settings
variable "os_name" {
  type        = string
  description = "Operating system name, i.e. Ubuntu"
  default     = "ubuntu"
}

variable "os_release" {
  type        = string
  description = "Ubuntu release, i.e. Plucky, Oracular, Noble, etc"
  default     = "plucky"
}

variable "os_arch" {
  type        = string
  description = "OS architecture, i.e. AMD64"
  default     = "amd64"
}

# Cloud Image Settings
variable "cloud_img_url" {
  type        = string
  description = "Cloud image download URL"
}

variable "cloud_img_name" {
  type        = string
  description = "Cloud image filename"
}

# VM Template General Settings
variable "template_vm_id" {
  type        = string
  description = "VM ID for the template, i.e. 9000"
  default     = "9000"
}

# VM Template CPU Settings
variable "template_vm_cpu_type" {
  type        = string
  description = "VM CPU type, i.e. x86-64-v2-AES, host, etc"
  default     = "x86-64-v2-AES"
}

# VM Template Memory Settings
variable "template_vm_memory" {
  type        = number
  description = "VM memory allocation, i.e. 2048"
  default     = 2048
}

# VM Template Network Bridge Settings
variable "template_vm_network_bridge" {
  type        = string
  description = "VM network bridge, i.e. vmbr0"
  default     = "vmbr0"
}

# VM Template Disk Settings
variable "proxmox_disk_image_volume" {
  type        = string
  description = "Proxmox disk image storage location, i.e. local-zfs"
  default     = "local-lvm"
}
