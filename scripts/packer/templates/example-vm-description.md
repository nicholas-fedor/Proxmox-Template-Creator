<!-- ❗❗❗
This file is used to provide the content for the vm's description in Proxmox.
Rename it to `vm-description.md` and update the content accordingly.
You can pass environment variables through to this, as long as they are exported.
❗❗❗ -->

# ${VM_NAME} Template

**Built**: ${BUILD_DATETIME}

## Customizations

- **Apt-Cacher Proxy**: <http://192.168.40.12:3142>
- **Update Command**: Runs `apt update && apt upgrade -y`
- **Time Sync**: Chrony with NTP server 192.168.20.20
- **Guest Agent**: QEMU Guest Agent enabled
