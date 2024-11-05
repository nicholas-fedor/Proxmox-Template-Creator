# Proxmox Template Creator

This is a tool for creating Ubuntu Cloud-Init templates on Proxmox using Packer.

## Usage

1. Configure the `/scripts/uploads/ssh-credentials.auto.pkvars.hcl` file with the appropriate credentials to SSH into the Proxmox host.

2. Configure build variables using the `/packer/template.auto.pkrvars.hcl` file.

3. Run the following command from the top-level directory using one of two options:

   a. Running Packer directly:

      ```console
      make
      ```

      This will:

      - Initialize Packer
      - Format the .hcl files
      - Validate the Packer configuration
      - Build the Proxmox template

   b. Running Packer via Docker Compose:

      ```console
      make run
      ```

      Expected Outcome:

      - Runs the `packer build` command within a Docker container.

4. The image will be built and uploaded to the Proxmox host.
5. Clone the image to generate a usable VM.
6. Configure settings in the `Cloud-Init` section, as needed.
   > The default user is `ubuntu`

## Program Logic

1. Downloads the cloud image on the Packer host
2. Uploads the image to the Proxmox host
3. Uploads the personalization script in uploads
4. Injects necessary environment variables
5. Uploads the create-template script and runs it:

   - Adds/updates libguestfs-tools for the virt-customize tool
   - Resizes the cloud image
   - Adds the QEMU Guest Agent to the cloud image
   - Runs the personalization script:

     - Adds configuration for local Apt-Cacher-NG server
     - Adds systemd-resolved DNS over TLS configuration
     - Installs Chrony
     - Adds local NTP server to Chrony
     - Adds executable `update` shell script to /usr/sbin
     - Modifies mirror URL to local mirror

   - Removes the personalization script fromtmp
   - Removes pre-existing template
   - Creates new template
   - Removes any dangling .img files from /tmp
