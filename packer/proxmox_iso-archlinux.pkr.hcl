packer {
  required_plugins {
    // https://developer.hashicorp.com/packer/plugins/builders/proxmox/iso
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_address" {
  type      = string
  default   = "NOT_SET"
  sensitive = false
}

variable "proxmox_node" {
  type      = string
  default   = "proxmox"
}

variable "proxmox_template_id" {
  type      = number
  default   = 900
}

variable "proxmox_username" {
  type      = string
  default   = "NOT_SET"
}

variable "proxmox_token" {
  type      = string
  sensitive = true
  default   = "NOT_SET"
}

variable "iso_url" {
  type      = string
  default   = "https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
}

variable "iso_checksum" {
  type      = string
  default   = "sha256:def774822f77da03b12ed35704e48f35ce61d60101071151a6d221994e0b567e"
}
variable "mirror_url" {
  type      = string
  default   = "https://geo.mirror.pkgbuild.com"

  validation {
    condition = !can(regex("[/][$]repo[/]os[/][$]arch$", var.mirror_url))
    error_message = "The URL path `/$repo/os/$arch` should be omitted."
  }
}

variable "ssh_keys_url" {
  type      = string
  default   = "NOTSET"
}
variable "mac_address" {
  type      = string
  default   = ""
}


source "proxmox-iso" "archlinux" {
  // boot_command          = [
  //                         "<wait5s>",
  //                         "<enter>",    # Boot Active Selection
  //                         "<wait25s>",  # Wait for boot
  //                         "curl http://{{ .HTTPIP }}:8080/proxmox/flakes.tar.gz -o flakes.tar.gz<enter><wait>",
  //                         "tar xfzv flakes.tar.gz && cd laptop && rm -rf .git<enter><wait>",

  //                         // EFI
  //                         // "sudo parted /dev/vda -- mklabel gpt && ",
  //                         // "sudo parted /dev/vda -- mkpart root ext4 512 -8GB && ",
  //                         // "sudo parted /dev/vda -- mkpart swap linux-swap -8GB 100% && ",
  //                         // "sudo parted /dev/vda -- mkpart ESP fat32 1MB 512MB"    # UEFI
  //                         // "sudo parted /dev/vda -- set 3 esp on"                  # UEFI
  //                         // "sudo mkfs.ext4 -L nixos /dev/vda1 && ",
  //                         // "sudo mkswap -L swap /dev/vda2 && ",
  //                         // "sudo mkfs.fat -F 32 -n boot /dev/vda3"                 # UEFI




  //                         // MBR
  //                         "sudo parted /dev/vda -- mklabel msdos && ",
  //                         "sudo parted /dev/vda -- mkpart primary 1MB -8GB && ",
  //                         "sudo parted /dev/vda -- set 1 boot on && ",
  //                         "sudo parted /dev/vda -- mkpart primary linux-swap -8GB 100% && ",
  //                         "sudo mkfs.ext4 -L nixos /dev/vda1 && ",
  //                         "sudo mkswap -L swap /dev/vda2 && ",



  //                         "sudo mount /dev/disk/by-label/nixos /mnt<enter><wait5s>",
  //                         "sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix<enter><wait>",
  //                         "sudo nixos-install --flake .#laptop"
  //                       ]

  boot_command          = [
                          "<wait5s>",
                          "<enter>",    # Boot Active Selection
                          "<wait25s>",  # Wait for boot
                          "date<enter>"
  ]

  boot_wait             = "2s"
  boot_key_interval     = "10ms"

  cores                 = 4
  memory                = 4096
  ballooning_minimum    = 2048

  disks {
    disk_size           = "32G"
    storage_pool        = "local-lvm"
    type                = "virtio"
  }

  bios                  = "seabios"
  os                    = "l26"

  iso_url               = "${var.iso_url}"
  iso_checksum          = "${var.iso_checksum}"
  iso_storage_pool      = "local"
  iso_download_pve      = true
  unmount_iso           = true

  network_adapters {
    bridge              = "vmbr0"
    model               = "virtio"
    mac_address         = "${var.mac_address}"
  }

  vm_id                 = "${var.proxmox_template_id}"

  node                  = "${var.proxmox_node}"
  proxmox_url           = "${var.proxmox_address}/api2/json"
  username              = "${var.proxmox_username}"
  token                 = "${var.proxmox_token}"

  template_description = "ArchLinux, generated on ${timestamp()}"
  template_name        = "archlinux"

  ssh_username          = "nixos"
  ssh_private_key_file  = "~/.ssh/id_rsa"
  ssh_timeout           = "20m"
}

build {
  sources = ["source.proxmox-iso.archlinux"]

  provisioner "shell" {
    inline = [
      "touch /tmp/debug",

      "ping -c 5 google.com",

      // "curl -L \\",
      //     "--output ./arch_installer.tar.gz \\",
      //     "https://github.com/husjon/arch_installer/archive/refs/tags/v0.2.4.tar.gz",
      //     // "https://github.com/husjon/arch_installer/archive/refs/heads/dev.tar.gz",
      // "tar xfv arch_installer.tar.gz",

      // "echo 'MIRRORS=(\"${var.mirror_url}/\\$repo/os/\\$arch\")' | tee -a ./arch_installer-*/global-variables.sh",

      // "./arch_installer-*/arch-install.sh packer_vm PRE-INSTALL && \\",
      // "rm /tmp/debug"
      ]
  }

  provisioner "shell" {
    inline = [
      "while [ -f /tmp/debug ]; do sleep 5; done"
    ]
  }
}
