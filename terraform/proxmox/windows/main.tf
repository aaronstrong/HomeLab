locals {
  # Convert the list of maps into a map keyed by the server name
  server_map = { for s in var.serverlist : s.name => s }
}

resource "proxmox_vm_qemu" "this" {
  for_each = local.server_map

  name        = each.value.name
  desc        = each.value.desc
  agent       = var.agent
  vmid        = each.value.vmid
  target_node = var.target_node

  # Template Settings
  clone      = each.value.clone
  full_clone = each.value.full_clone

  # Boot Process
  onboot           = var.onboot
  boot             = var.boot
  startup          = var.startup
  automatic_reboot = var.automatic_reboot

  # Hardware settings
  qemu_os  = each.value.qemu_os
  bios     = "ovmf"
  cores    = each.value.cores
  sockets  = each.value.sockets
  cpu_type = "host"
  memory   = each.value.memory
  balloon  = each.value.ballon

  # Network Settings
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Disk Settings
  scsihw = "virtio-scsi-single"

  # IDE0 Disk Configuration (Cloud Init)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = each.value.ide0.storage
        }
      }
    }

    # SCSI0 Disk Configuration
    scsi {
      scsi0 {
        disk {
          storage  = each.value.scsi0.storage
          size     = each.value.scsi0.size
          iothread = each.value.scsi0.iothread
          cache    = each.value.scsi0.cache
          discard  = each.value.scsi0.discard
        }
      }
    }
  }

  # Cloud Init Settings
  ipconfig0    = "ip=${each.value.static_ip}/${var.cidr},gw=${var.gateway}"
  nameserver   = var.nameserver
  ciuser       = each.value.ciuser
  cipassword   = each.value.cipassword
  searchdomain = var.searchdomain
}
