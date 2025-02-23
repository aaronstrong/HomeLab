# PROXMOX VM Creation

Module creates VM instances on a PROXMOX host.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.1-rc6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 3.0.1-rc6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.this](https://registry.terraform.io/providers/Telmate/proxmox/3.0.1-rc6/docs/resources/vm_qemu) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent"></a> [agent](#input\_agent) | Set to 1 to enable the QEMU Guest Agent. | `number` | `1` | no |
| <a name="input_automatic_reboot"></a> [automatic\_reboot](#input\_automatic\_reboot) | n/a | `bool` | `false` | no |
| <a name="input_boot"></a> [boot](#input\_boot) | Boot order | `string` | `"order=scsi0;net0"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | n/a | `string` | `"24"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | n/a | `string` | `"192.168.4.1"` | no |
| <a name="input_nameserver"></a> [nameserver](#input\_nameserver) | n/a | `string` | `"127.0.0.1 192.168.4.1"` | no |
| <a name="input_onboot"></a> [onboot](#input\_onboot) | Whether to have the VM startup after the PVE node starts. | `bool` | `true` | no |
| <a name="input_proxmox_api_token_id"></a> [proxmox\_api\_token\_id](#input\_proxmox\_api\_token\_id) | The token id. | `string` | n/a | yes |
| <a name="input_proxmox_api_token_secret"></a> [proxmox\_api\_token\_secret](#input\_proxmox\_api\_token\_secret) | The secret assigned to the token id. | `string` | n/a | yes |
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | The IP Address of the ProxMox server. | `string` | n/a | yes |
| <a name="input_proxmox_tls_insecure"></a> [proxmox\_tls\_insecure](#input\_proxmox\_tls\_insecure) | Change to true if you are using self-signed certificates | `bool` | `true` | no |
| <a name="input_searchdomain"></a> [searchdomain](#input\_searchdomain) | n/a | `string` | `"demolab.local"` | no |
| <a name="input_serverlist"></a> [serverlist](#input\_serverlist) | n/a | <pre>list(object({<br/>    name       = string<br/>    desc       = string<br/>    vmid       = number<br/>    clone      = string # Template to clone<br/>    full_clone = string # True for full clone, false for linked clone<br/>    static_ip  = string<br/>    ciuser     = string<br/>    cipassword = string<br/>    cores      = number<br/>    sockets    = number<br/>    memory     = number<br/>    ballon     = number<br/>    qemu_os    = string<br/><br/>    # Disk Configuration<br/>    ide0 = object({<br/>      storage   = string<br/>      cloudinit = bool<br/>    })<br/>    scsi0 = object({<br/>      storage  = string<br/>      size     = string<br/>      iothread = bool<br/>      cache    = string<br/>      discard  = bool<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_startup"></a> [startup](#input\_startup) | startup stripts | `string` | `""` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | Name of the proxmox server. | `string` | `"pmox1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->