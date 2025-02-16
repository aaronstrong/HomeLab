terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

variable "PUBLIC_SSH_KEY" {
  
  # -- Public SSH Key, you want to upload to VMs and LXC containers.

  type = string
  sensitive = true
}

variable "proxmox_tls_insecure" {
  description = "Change to true if you are using self-signed certificates"
  default     = true
}

provider "proxmox" {
  # Configuration options
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure  # <-- (Optional) Change to true if you are using self-signed certificates
}
