variable "vm_enable" {
  description = "Enables or Disables VM creation. Defaults to false"
  type        = bool
  default     = true
}

variable "name" {
  description = "name of the vm"
  type        = string
  default     = "tf-vm"
}

variable "desc" {
  description = "VM description"
  type        = string
  default     = "managed by terraform"
}

variable "agent" {
  default = 1
}

variable "vmid" {
  default = "200"
}

variable "target_node" {
  description = "Name of the proxmox server."
  type        = string
  default     = "pmox1"
}

variable "clone" {
  default = "w2025-init"
}

variable "full_clone" {
  default = false
}

variable "onboot" {
  default = true
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

variable "static_ip" {
  default = "192.168.4.51"
}

variable "cidr" {
  default = "24"
}

variable "gateway" {
  default = "192.168.4.1"
}

variable "ciuser" {
  default = "Admin"
}

variable "cipassword" {
  default = "P@ssw0rd"
}

variable "nameserver" {
  default = "127.0.0.1,192.168.4.1"
}

variable "searchdomain" {
  default = "demolab.local"
}


variable "serverlist" {
  type = list(map(string))
  default = [
    {
      name       = "dc1"
      vmid       = "200"
      static_ip  = "192.168.4.62"
      ciuser     = "Admin"
      cipassword = "password"
      cores      = 2
      sockets    = 2
      memory     = 8196
      ballon     = 4096
      qemu_os    = "win11"
    },
    {
      name       = "dc2"
      vmid       = "201"
      static_ip  = "192.168.4.63"
      ciuser     = "Admin"
      cipassword = "password"
      cores      = 2
      sockets    = 2
      memory     = 8196
      ballon     = 4096
      qemu_os    = "win11"
    },
  ]
}