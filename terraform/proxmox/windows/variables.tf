variable "proxmox_api_url" {
  description = "The IP Address of the ProxMox server."
  type        = string
}

variable "proxmox_api_token_id" {
  description = "The token id."
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "The secret assigned to the token id."
  type        = string
}

variable "proxmox_tls_insecure" {
  description = "Change to true if you are using self-signed certificates"
  default     = true
}

variable "agent" {
  description = "Set to 1 to enable the QEMU Guest Agent."
  type        = number
  default     = 1
}

variable "target_node" {
  description = "Name of the proxmox server."
  type        = string
  default     = "pmox1"
}

variable "onboot" {
  description = "Whether to have the VM startup after the PVE node starts."
  type        = bool
  default     = true
}

variable "boot" {
  description = "Boot order"
  type        = string
  default     = "order=scsi0;net0"
}

variable "startup" {
  description = "startup stripts"
  type        = string
  default     = ""
}

variable "automatic_reboot" {
  default = false
}

variable "cidr" {
  default = "24"
}

variable "gateway" {
  default = "192.168.4.1"
}

variable "nameserver" {
  default = "127.0.0.1 192.168.4.1"
}

variable "searchdomain" {
  default = "demolab.local"
}

variable "serverlist" {
  type = list(object({
    name       = string
    desc       = string
    vmid       = number
    clone      = string # Template to clone
    full_clone = string # True for full clone, false for linked clone
    static_ip  = string
    ciuser     = string
    cipassword = string
    cores      = number
    sockets    = number
    memory     = number
    ballon     = number
    qemu_os    = string

    # Disk Configuration
    ide0 = object({
      storage   = string
      cloudinit = bool
    })
    scsi0 = object({
      storage  = string
      size     = string
      iothread = bool
      cache    = string
      discard  = bool
    })
  }))
  default = []
}
