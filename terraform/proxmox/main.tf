resource "proxmox_vm_qemu" "this" {
  name        = "tf-vm"
  desc        = "managed by terraform"
  agent       = 1
  vmid        = "121"
  target_node = "pmox1"

  # Template Settings

  clone      = "w2025-init"
  full_clone = false

  # Boot Process
  onboot           = true
  boot             = "order=scsi0;net0"
  startup          = ""
  automatic_reboot = false


  # Hardware settings
  qemu_os  = "win11"
  bios     = "ovmf"
  cores    = 2
  sockets  = 2
  cpu_type = "host"
  memory   = 8196
  balloon  = 4096


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
  ipconfig0    = "ip=<static_ip>/24,gw=<gateway_address>"
  nameserver   = "<nameservers>"
  ciuser       = "<username>"
  cipassword   = "<password>"
  searchdomain = "demolab.local"
}
