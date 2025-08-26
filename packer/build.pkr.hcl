# Build Definitions
# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  # Uses the null.proxmox source defined in source.pkr.hcl
  # for creating an SSH connection with the Proxmox host,
  # which is subsequently used by the provisioners
  sources = ["sources.null.proxmox"]

  # Checks for curl, installs if missing, and downloads the cloud image
  # directly to /tmp on the Proxmox host
  # https://developer.hashicorp.com/packer/docs/provisioners/shell
  provisioner "shell" {
    inline = [
      "if ! command -v curl > /dev/null; then",
      "  apt update",
      "  apt install -y curl",
      "fi",
      "curl -o /tmp/${var.cloud_img_name} ${var.cloud_img_url}"
    ]
  }

  # Uploads ./scripts/packer/uploads/personalize.sh to /tmp on the Proxmox host
  # https://developer.hashicorp.com/packer/docs/provisioners/file
  provisioner "file" {
    source      = "./scripts/packer/uploads/personalize.sh"
    destination = "/tmp/personalize.sh"
  }

  # Uploads ./scripts/packer/templates/vm-description.md to /tmp on the Proxmox host
  provisioner "file" {
  source      = "./scripts/packer/templates/vm-description.md"
  destination = "/tmp/vm-description.md"
  }

  # Uploads and executes the create-template.sh shell script on the Proxmox host
  provisioner "shell" {
    environment_vars = [
      # Proxmox Host Disk Image Volume
      "PROXMOX_DISK_IMAGE_VOLUME=${var.proxmox_disk_image_volume}",
      # Cloud Image Settings
      "CLOUD_IMG_NAME=${var.cloud_img_name}",
      # VM Template General Settings
      "VM_ID=${var.template_vm_id}",
      "VM_NAME=${var.os_name}-${var.os_release}",
      # VM Template OS Settings
      "VM_CPU_TYPE=${var.template_vm_cpu_type}",
      # VM Template Memory Settings
      "VM_MEMORY=${var.template_vm_memory}",
      # VM Template Network Bridge
      "VM_NETWORK_BRIDGE=${var.template_vm_network_bridge}",
      # VM Template Tags
      "VM_TAGS=template;${var.os_name};${var.os_release}",
    ]
    script = "./scripts/packer/create-template.sh"
  }
}
