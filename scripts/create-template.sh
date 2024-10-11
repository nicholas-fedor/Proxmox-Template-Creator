#!/usr/bin/env sh

# Shell script to create an Ubuntu server template on Proxmox
# The template uses Cloud Init for futher customizations.
# The Ubuntu cloud init image has a default user of "ubuntu" and no password.
# 
# Proxmox QEMU Manager documentation: https://pve.proxmox.com/pve-docs/chapter-qm.html
# Proxmox QEMU CLI command documentation: https://pve.proxmox.com/pve-docs/qm.1.html
# virt-customize documentation: https://www.libguestfs.org/virt-customize.1.html

# Download dependencies
apt update -y && apt install -y libguestfs-tools --no-install-recommends

# Resize cloud image
qemu-img resize /tmp/$CLOUD_IMG_NAME 32G

# Add QEMU-Guest-Agent to image
virt-customize -a /tmp/$CLOUD_IMG_NAME --install qemu-guest-agent

# Add personal configurations
virt-customize -a /tmp/$CLOUD_IMG_NAME --run /tmp/personalize.sh
rm /tmp/personalize.sh || echo "personalize.sh script not present"

# Remove existing template
qm destroy $VM_ID --destroy-unreferenced-disks --purge || echo "VM not present"

# Generate BUILD_DATETIME
BUILD_DATETIME=$(date +"%Y-%m-%d at %H:%M")

# Create a new VM 
qm create $VM_ID \
--name $VM_NAME \
--description "$VM_NAME template built on $BUILD_DATETIME by Packer" \
--ostype l26 \
--machine q35 \
--bios ovmf \
--efidisk0 file=$PROXMOX_DISK_IMAGE_VOLUME:1,pre-enrolled-keys=0,efitype=4m,format=raw \
--scsihw virtio-scsi-single \
--agent enabled=1 \
--scsi0 $PROXMOX_DISK_IMAGE_VOLUME:0,import-from=/tmp/$CLOUD_IMG_NAME,ssd=1,iothread=1,cache=writeback,discard=on \
--ide2 $PROXMOX_DISK_IMAGE_VOLUME:cloudinit \
--cpu cputype=$VM_CPU_TYPE \
--memory $VM_MEMORY \
--net0 virtio,bridge=vmbr0 \
--ipconfig0 ip=dhcp,ip6=dhcp \
--boot order=scsi0 \
--tags $VM_TAGS

# Create Template
qm template $VM_ID

# Cleanup *.img files
rm /tmp/*.img