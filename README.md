# Proxmox Template Creator

Automation for creating customized Ubuntu VM Cloud-Init templates on Proxmox.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
    - [Required](#required)
    - [Optional](#optional)
  - [Installing Dependencies](#installing-dependencies)
    - [Packer](#packer)
    - [Task](#task)
    - [Shellcheck](#shellcheck)
    - [Docker](#docker)
  - [Proxmox User Setup](#proxmox-user-setup)
- [Scripting](#scripting)
  - [Taskfile](#taskfile)
  - [Makefile](#makefile)
- [VM Creation](#vm-creation)
- [Program Logic](#program-logic)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Third-Party Tools](#third-party-tools)
- [Contributing](#contributing)

## Overview

Proxmox allows users to create virtual machine (VM) templates, which can be used to quickly create virtual machines with a variety of pre-configured options.

Hashicorp's Packer makes it possible to automate this process. In addition, using Cloud-Init enables further flexibility in VM management and flexibility.

This project attempts to provide several options for running Packer, including using Packer directly or via a Docker container. In addition, Packer can be invoked either directly, using the provided Makefile, or by using Task scripts.

---

[Back to Top](#proxmox-template-creator)

## Getting Started

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installing Dependencies](#installing-dependencies)
- [Proxmox User Setup](#proxmox-user-setup)

### Quick Start

1. Clone the repository:

   ```bash
   git clone https://github.com/nicholas-fedor/Proxmox-Template-Creator.git
   cd Proxmox-Template-Creator
   ```

2. Install Packer.
   <!-- TODO: Add link to installing Packer -->

3. Configure SSH access to your Proxmox host (see SSH Configuration for details).
    <!-- TODO: Add link to SSH Configuration section -->

4. Rename and update `packer/proxmox-host.auto.pkrvars.hcl` to reference your target host's IP or FQDN:

   ```hcl
   ssh_host = "proxmox.example.com"
   ```

5. Update `packer/proxmox-template.auto.pkrvars.hcl` with any desired options for the VM template settings.

6. Build the template:

   ```bash
   packer build ./packer
   ```

[Back to Getting Started](#getting-started)

### Prerequisites

#### Required

- **Proxmox VE**: A running host with SSH access enabled.
- **Packer**: v1.10+ for building VM templates.
- **SSH Keys**: Configured for passwordless access to the Proxmox host.

#### Optional

- **Make**: CLI automation tool.
- **Task**: Cross-platform Make alternative.
- **Shellcheck**: For linting shell scripts.
- **Docker**: For running Packer via a Docker container.

[Back to Getting Started](#getting-started)

### Installing Dependencies

If you already have Task installed, you can use it to install the required dependencies:

```bash
task install
```

#### Packer

Bash:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install -y packer
```

PowerShell:

```powershell
winget install HashiCorp.Packer
```

#### Task

Bash:

```bash
LATEST_TAG=$(curl -s https://api.github.com/repos/go-task/task/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/go-task/task/releases/download/${LATEST_TAG}/task_linux_amd64.tar.gz" | sudo tar -xzf - -C /usr/local/bin task
```

PowerShell:

```powershell
$LATEST_TAG = (Invoke-RestMethod -Uri 'https://api.github.com/repos/go-task/task/releases/latest').tag_name
Invoke-WebRequest -Uri "https://github.com/go-task/task/releases/download/$LATEST_TAG/task_windows_amd64.zip" -OutFile task.zip
Expand-Archive task.zip -DestinationPath $env:SYSTEMROOT\System32
Remove-Item task.zip
```

#### Shellcheck

Bash:

```bash
LATEST_TAG=$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/koalaman/shellcheck/releases/download/${LATEST_TAG}/shellcheck-${LATEST_TAG}.linux.x86_64.tar.xz" | sudo tar -xJf - -C /usr/local/bin --strip-components=1 shellcheck-${LATEST_TAG}/shellcheck
```

PowerShell:

```powershell
$LATEST_TAG = (Invoke-RestMethod -Uri 'https://api.github.com/repos/koalaman/shellcheck/releases/latest').tag_name
Invoke-WebRequest -Uri "https://github.com/koalaman/shellcheck/releases/download/$LATEST_TAG/shellcheck-$LATEST_TAG.zip" -OutFile shellcheck.zip
Expand-Archive shellcheck.zip -DestinationPath $env:SYSTEMROOT\System32
Remove-Item shellcheck.zip
```

#### Docker

Bash:

```bash
curl -fsSL https://get.docker.com | sh
```

PowerShell:

```powershell
Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -OutFile DockerDesktopInstaller.exe
Start-Process -FilePath .\DockerDesktopInstaller.exe -Wait
Remove-Item DockerDesktopInstaller.exe
```

[Back to Getting Started](#getting-started)

### Proxmox User Setup

A user with SSH and root privileges is required on the Proxmox host.

1. Create a user via the Proxmox webGUI:

   ```console
   Datacenter > Permissions > Users > Add
   ```

   - Username: `hashicorp`
   - Realm: `Linux PAM standard authentication`
   - Password: `<your-password>`

2. Create the user on the Proxmox host:

   ```bash
   useradd hashicorp
   ```

3. Set a password via the webGUI:

   ```console
   Datacenter > Permissions > Users > [Select hashicorp] > Password
   ```

4. Install `sudo`:

   ```bash
   apt install sudo -y
   ```

5. Add `hashicorp` to `sudo` and `kvm` groups:

   ```bash
   adduser hashicorp sudo
   adduser hashicorp kvm
   ```

6. Set up a home directory:

   ```bash
   mkdir /home/hashicorp
   cp -rT /etc/skel /home/hashicorp
   chown -R hashicorp:hashicorp /home/hashicorp
   ```

7. Add your SSH public key to the `hashicorp` user's `authorized_keys` (from the Packer host):

   ```bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub hashicorp@<proxmox-host>
   ```

8. Configure `sudoers` for passwordless root access:

   ```bash
   echo "hashicorp ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/hashicorp
   ```

[Back to Getting Started](#getting-started)

---

[Back to Top](#proxmox-template-creator)

## Scripting

- [Taskfile](#taskfile)
- [Makefile](#makefile)

### Taskfile

Run `task help` to list available tasks.

- **Check Dependencies**:

  ```bash
  task check
  ```

  Verifies tools (Packer, Shellcheck, Docker).

- **Build Template**:

  ```bash
  task build
  ```

  Lints scripts, cleans, and runs Packer to create the template.

- **Validate Configuration**:

  ```bash
  task validate
  ```

  Checks Packer configuration.

- **Clean Up**:

  ```bash
  task clean
  ```

  Removes temporary files and Packer cache.

- **Lint Scripts**:

  ```bash
  task lint
  ```

  Lints `create-template.sh` and `personalize.sh`.

- **Docker Build**:

  ```bash
  task docker-build
  ```

  Runs Packer in a Docker container (requires Docker).

- **Install Tools**:

  ```bash
  task install
  ```

- **Debug**:

  ```bash
  task debug-os     # Print current OS
  task debug-shell  # Print current shell
  ```

[Back to Scripting](#scripting)

### Makefile

The Makefile provides a straightforward alternative for running Packer operations, particularly for users familiar with Make-based workflows. It handles initialization, formatting, validation, and building of the Proxmox template, with support for Docker-based builds.

- **Run Full Build Workflow**:

  ```bash
  make
  ```

  Executes the full pipeline:
  - Initializes Packer (`init`).
  - Formats Packer HCL files (`fmt`).
  - Validates the configuration (`validate`)
  - Builds the template (`build`).

- **Initialize Packer**:

  ```bash
  make init
  ```

  Runs `packer init ./packer` to set up Packer plugins and configuration.

- **Format HCL Files**:

  ```bash
  make fmt
  ```

  Runs `packer fmt ./packer` to ensure consistent formatting of HCL files.

- **Validate Configuration**:

  ```bash
  make validate
  ```

  Validates the Packer configuration and removes temporary files.

- **Build Template**:

  ```bash
  make build
  ```

  Runs the Packer build and removes temporary files.

- **Docker Build**:

  ```bash
  make run
  ```

  Executes the Packer build in a Docker container using `docker-compose.yml`, requiring internet access on the Proxmox host for image download.

> [!NOTE]
> The Makefile requires users to edit it to specify the desired credentials file in `packer/credentials/` by setting the `CREDENTIALS_FILE` variable, or override it via the environment variable:
>
> ```bash
> CREDENTIALS_FILE=packer/credentials/<your-file>.auto.pkrvars.json make
> ```

[Back to Scripting](#scripting)

---

[Back to Top](#proxmox-template-creator)

## VM Creation

- **Manual**:
  - Clone the template via the Proxmox webGUI (use full clone).
  - Update Cloud-Init settings (default user: `ubuntu`).
  - Before starting the VM, copy the MAC address and configure DHCP reservation/DNS entry.

---

[Back to Top](#proxmox-template-creator)

## Program Logic

1. **Download Cloud Image**:
   - Uses `curl` on the Proxmox host to download to `/tmp` (installs `curl` if missing).
2. **Upload Files**:
   - Transfers `personalize.sh` to Proxmox via SSH.
3. **Customize Image**:
   - Installs `libguestfs-tools` if needed.
   - Resizes image to 32G.
   - Installs QEMU Guest Agent.
   - Runs `personalize.sh` (configures Apt-Cacher proxy, DNS over TLS, Chrony NTP, local mirror, `update` script).
4. **Create Template**:
   - Destroys existing template if present.
   - Creates VM with specified settings (CPU, memory, network, etc.).
   - Converts to template.
5. **Cleanup**:
   - Removes temporary files on Proxmox host.

---

[Back to Top](#proxmox-template-creator)

## Customization

- **Variables**: Edit `packer/template.auto.pkrvars.hcl` for cloud image URL, VM ID, CPU, memory, network bridge.
- **Scripts**:
  - `create-template.sh`: Manages VM creation and cleanup.
  - `personalize.sh`: Add custom packages or configurations (e.g., NTP servers, mirrors).
- **Credentials**: Use multiple files in `packer/credentials/` for different hosts; set `CREDENTIALS_FILE` env var.

---

[Back to Top](#proxmox-template-creator)

## Troubleshooting

- **Packer Issues**: Run `task validate` for configuration errors.
- **SSH Issues**: Confirm `hashicorp` user credentials, SSH keys, and sudo access.
- **Platform Issues**: Use `task debug-os` and `task debug-shell` for environment checks.

---

[Back to Top](#proxmox-template-creator)

## Third-Party Tools

| Tool           | Description                 | GitHub Repository                        |
|----------------|-----------------------------|------------------------------------------|
| **Docker**     | Containerization for builds | <https://github.com/moby/moby>           |
| **Packer**     | Creates machine images      | <https://github.com/hashicorp/packer>    |
| **Shellcheck** | Shell script analysis       | <https://github.com/koalaman/shellcheck> |
| **Taskfile**   | Task runner                 | <https://github.com/go-task/task>        |

---

[Back to Top](#proxmox-template-creator)

## Contributing

Contributions are welcome! Fork the repository, make changes, and submit a pull request.

---
[Back to Top](#proxmox-template-creator)
