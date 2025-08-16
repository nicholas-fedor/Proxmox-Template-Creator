# Automatically loaded environment variables for build.pkr.hcl
# The variable definitions can be found in variables.pkr.hcl

# OS Settings
os_name    = "ubuntu" # Default: ubuntu
os_release = "plucky" # Default: plucky
os_arch    = "amd64"  # Default: amd64

# Cloud Image Download URL
cloud_img_url  = "https://cloud-images.ubuntu.com/plucky/current/plucky-server-cloudimg-amd64.img"
# Cloud Image Filename
cloud_img_name = "plucky-server-cloudimg-amd64.img"

# VM Template General Settings (Default: 9000)
template_vm_id = "9000"

# VM Template CPU Settings (Default: x86-64-v2-AES)
template_vm_cpu_type = "host"

# VM Template Memory Settings (Default: 2048 MB, i.e. 2GB)
template_vm_memory = 4096

# Proxmox Host Disk Image Volume (Default: local-lvm)
# proxmox_disk_image_volume = "local-lvm"
proxmox_disk_image_volume = "local-zfs"
# proxmox_disk_image_volume = "cephpool"


# VM Template Network Bridge Settings (Default: vmbr0)
template_vm_network_bridge = "vmbr0" #
# template_vm_network_bridge = "vmbr1"
