// build.pkr.hcl

build {
  // Uses the null.proxmox source for creating an SSH connection with the Proxmox host, 
  // which is subsequently used by the provisioners
  sources = ["sources.null.proxmox"]

  // https://developer.hashicorp.com/packer/docs/provisioners/shell-local
  // Downloads the cloud image to the Packer host downloads subdirectory
  provisioner "shell-local" {
    inline = ["wget -P ./downloads -nc --continue --show-progress --progress=dot:giga ${var.cloud_img_url}"]
  }

  // https://developer.hashicorp.com/packer/docs/provisioners/file
  // Uploads ./downloads to /tmp on the Proxmox host 
  provisioner "file" {
    source      = "./downloads/"
    destination = "/tmp"
  }

  // Uploads ./scripts/upload/personalize.sh to /tmp on the Proxmox host 
  provisioner "file" {
    source      = "./scripts/uploads/personalize.sh"
    destination = "/tmp/personalize.sh"
  }

  // https://developer.hashicorp.com/packer/docs/provisioners/shell
  // Uploads and executes the create-template.sh shell script on the Proxmox host
  provisioner "shell" {
    environment_vars = [
      // Proxmox Host Disk Image Volume
      "PROXMOX_DISK_IMAGE_VOLUME=${var.proxmox_disk_image_volume}",
      // Cloud Image Settings
      "CLOUD_IMG_URL=${var.cloud_img_url}",
      "CLOUD_IMG_NAME=${var.cloud_img_name}",
      // VM Template General Settings
      "VM_ID=${var.template_vm_id}",
      "VM_NAME=${var.os_name}-${var.os_release}",
      // VM Template OS Settings
      "VM_CPU_TYPE=${var.template_vm_cpu_type}",
      // VM Template Memory Settings
      "VM_MEMORY=${var.template_vm_memory}",
      // VM Template Tags
      "VM_TAGS=template;${var.os_name};${var.os_release}",
    ]
    script = "./scripts/create-template.sh"
  }
}