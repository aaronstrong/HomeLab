locals {
  # Convert the list of maps into a map keyed by the server name
  server_map = { for s in var.serverlist : s.name => s }
}


resource "proxmox_vm_qemu" "this" {
  for_each = local.server_map

  name        = each.value.name
  desc        = var.desc
  agent       = var.agent
  vmid        = each.value.vmid
  target_node = var.target_node

  # Template Settings

  clone      = var.clone
  full_clone = var.full_clone

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

  #The drive types and numbers need to match with what's in the master template/clone
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "bigStorage"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage  = "bigStorage"
          size     = "100G"
          iothread = true
          cache    = "writeback"
          discard  = "true"
        }
      }
    }

    # virtio {
    #   virtio0 {
    #     disk {
    #       storage  = "bigStorage"
    #       size     = "100G" # <-- Change the desired disk size, ! since 3.x.x size change will trigger a disk resize
    #       iothread = true   # <-- (Optional) Enable IOThread for better disk performance in virtio-scsi-single
    #       #replicate = false  # <-- (Optional) Enable for disk replication
    #       cache   = "writeback"
    #       discard = "true"
    #     }
    #   }
    # }
  }

  # -- Cloud Init Settings
  ipconfig0    = "ip=${each.value.static_ip}/${var.cidr},gw=${var.gateway}"
  nameserver   = var.nameserver
  ciuser       = each.value.ciuser
  cipassword   = each.value.cipassword
  searchdomain = var.searchdomain
}
