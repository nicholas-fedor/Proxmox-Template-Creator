// template.auto.pkrvars.hcl

// Variable definitions: variables.pkr.hcl

// build.pkr.hcl Variables
// Proxmox Host Disk Image Volume
proxmox_disk_image_volume = "local-zfs"
// OS Settings
os_name    = "ubuntu"
os_release = "oracular"
os_arch    = "amd64"
// Cloud Image Settings
cloud_img_url  = "https://cloud-images.ubuntu.com/oracular/current/oracular-server-cloudimg-amd64.img"
cloud_img_name = "oracular-server-cloudimg-amd64.img"
// VM Template General Settings
template_vm_id = "9000"
// VM Template CPU Settings
template_vm_cpu_type = "host"
// VM Template Memory Settings
template_vm_memory = 4096
// VM Template Network Bridge
template_vm_network_bridge = "vmbr0"
# template_vm_network_bridge = "vmbr1"