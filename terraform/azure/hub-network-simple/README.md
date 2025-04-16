# Terraform Module to deploy an Azure Hub


## Architecture
![](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/_images/hub-spoke.png)


## [Logging into the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

Firstly, login to the Azure CLI using a User Account

```json
az login
```

Once logged in - it's possible to list the Subscriptions associated with the account via:

```json
az account list
```

The output (similar to below) will display one or more Subscriptions - with the `id` filed being the `subscription_id` field referenced above.

```json
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
```


## Connect to Linux instance

To get the private key
```git
terraform output -json tls_private_key | jq -r '.[0]' > azureuser_id_rsa
```

change the permissions on the key

```
chmod 400 azureuser_id_rsa
```

and then connect to the VM using SSH commands:

```git
ssh -i azureuser_id_rsa azureuser@<public_ip>
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_azure_firewall"></a> [create\_azure\_firewall](#input\_create\_azure\_firewall) | Toggle to create the Azure Firewall. | `bool` | `false` | no |
| <a name="input_create_ddos_plan"></a> [create\_ddos\_plan](#input\_create\_ddos\_plan) | Create an ddos plan - Default is false | `bool` | `false` | no |
| <a name="input_create_network_watcher"></a> [create\_network\_watcher](#input\_create\_network\_watcher) | Controls if Network Watcher resources should be created for the Azure subscription | `bool` | `false` | no |
| <a name="input_create_private_load_balancer"></a> [create\_private\_load\_balancer](#input\_create\_private\_load\_balancer) | Toggle to create an Azure internal load balancer | `bool` | `false` | no |
| <a name="input_create_vpn_gateway"></a> [create\_vpn\_gateway](#input\_create\_vpn\_gateway) | Controls if VPN Gateway resources should be created | `bool` | `false` | no |
| <a name="input_create_windows_vm"></a> [create\_windows\_vm](#input\_create\_windows\_vm) | Toggle to create a Windows VM with website. | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for virtual network | `list(any)` | `[]` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Azure existing resource group name | `string` | `""` | no |
| <a name="input_firewall_application_rules"></a> [firewall\_application\_rules](#input\_firewall\_application\_rules) | List of application rules to apply to firewall. | <pre>list(object({<br/>    name             = string,<br/>    action           = string,<br/>    source_addresses = list(string),<br/>    target_fqdns     = list(string),<br/>    protocol = object({<br/>      type = string,<br/>      port = string<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_firewall_nat_rules"></a> [firewall\_nat\_rules](#input\_firewall\_nat\_rules) | List of nat rules to apply to firewall. | <pre>list(object({<br/>    name                  = string, action = string,<br/>    source_addresses      = list(string),<br/>    destination_ports     = list(string),<br/>    destination_addresses = list(string),<br/>    protocols             = list(string),<br/>    translated_address    = string,<br/>    translated_port       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_firewall_network_rules"></a> [firewall\_network\_rules](#input\_firewall\_network\_rules) | List of network rules to apply to firewall. | <pre>list(object({<br/>    name                  = string,<br/>    action                = string,<br/>    source_addresses      = list(string),<br/>    destination_ports     = list(string),<br/>    destination_addresses = list(string),<br/>    protocols             = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_firewall_service_endpoints"></a> [firewall\_service\_endpoints](#input\_firewall\_service\_endpoints) | Service endpoints to add to the firewall subnet | `list(string)` | <pre>[<br/>  "Microsoft.AzureActiveDirectory",<br/>  "Microsoft.AzureCosmosDB",<br/>  "Microsoft.EventHub",<br/>  "Microsoft.KeyVault",<br/>  "Microsoft.ServiceBus",<br/>  "Microsoft.Sql",<br/>  "Microsoft.Storage"<br/>]</pre> | no |
| <a name="input_firewall_subnet_address_prefix"></a> [firewall\_subnet\_address\_prefix](#input\_firewall\_subnet\_address\_prefix) | The address prefix to use for the Firewall subnet | `list(any)` | <pre>[<br/>  "10.0.0.0/26"<br/>]</pre> | no |
| <a name="input_firewall_zones"></a> [firewall\_zones](#input\_firewall\_zones) | A collection of availability zones to spread the Firewall over | `list(string)` | `[]` | no |
| <a name="input_gateway_service_endpoints"></a> [gateway\_service\_endpoints](#input\_gateway\_service\_endpoints) | Service endpoints to add to the Gateway subnet | `list(string)` | `[]` | no |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | The address prefix to use for the gateway subnet | `list(any)` | <pre>[<br/>  "10.0.1.0/27"<br/>]</pre> | no |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | The name of the virtual network | `string` | `"hub"` | no |
| <a name="input_lb_frontend_ip_name"></a> [lb\_frontend\_ip\_name](#input\_lb\_frontend\_ip\_name) | The name to give to the frontend ip configuration | `string` | `"frontend-ilb"` | no |
| <a name="input_lb_hc_probe"></a> [lb\_hc\_probe](#input\_lb\_hc\_probe) | Load balancer health check probes | <pre>map(object({<br/>    port                = number<br/>    interval_in_seconds = optional(number)<br/>    number_of_probes    = optional(number)<br/>    protocol            = string # Tcp or Udp<br/>  }))</pre> | <pre>{<br/>  "hc-probe-80": {<br/>    "port": 80,<br/>    "protocol": "Tcp"<br/>  }<br/>}</pre> | no |
| <a name="input_lb_ip_address_allocation"></a> [lb\_ip\_address\_allocation](#input\_lb\_ip\_address\_allocation) | The allocation method for the Private IP Address. Accepts values of `Dynamic` and `Static`. | `string` | `"Dynamic"` | no |
| <a name="input_lb_ip_address_static"></a> [lb\_ip\_address\_static](#input\_lb\_ip\_address\_static) | The static IP address to assign to the lb | `string` | `"10.0.2.21"` | no |
| <a name="input_lb_rule"></a> [lb\_rule](#input\_lb\_rule) | Load balancer rule(s). `probe_name` must match key from `lb_hc_probe`. | <pre>map(object({<br/>    protocol              = string<br/>    frontend_port         = number<br/>    backend_port          = number<br/>    disable_outbound_snat = optional(bool)<br/>    probe_name            = optional(string) # NEW: optional health probe key<br/>  }))</pre> | <pre>{<br/>  "rule-1": {<br/>    "backend_port": 80,<br/>    "frontend_port": 80,<br/>    "probe_name": "hc-probe-80",<br/>    "protocol": "Tcp"<br/>  }<br/>}</pre> | no |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku) | The SKU of the Azure Load Balancer. Accepts values of `Basic`, `Standard`, and `Gateway`. | `string` | `"Standard"` | no |
| <a name="input_lb_sku_tier"></a> [lb\_sku\_tier](#input\_lb\_sku\_tier) | The SKU tier of this Load Balancer. Accepts values of `Global` and `Regional`. | `string` | `"Regional"` | no |
| <a name="input_linux_vm_name"></a> [linux\_vm\_name](#input\_linux\_vm\_name) | Enter desired name for a linux vm. | `list(string)` | `[]` | no |
| <a name="input_local_networks"></a> [local\_networks](#input\_local\_networks) | List of local virtual network connections to connect to gateway | `list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `"centralus"` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | The name of the Private DNS zone | `string` | `"publiccloud.example.com"` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | The public ip allocation method. `Dynamic` or `Static`, default is `Dynamic` | `string` | `"Dynamic"` | no |
| <a name="input_public_ip_names"></a> [public\_ip\_names](#input\_public\_ip\_names) | Public ips is a list of ip names that are connected to the firewall. At least one is required. | `list(string)` | <pre>[<br/>  "fw-public"<br/>]</pre> | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | The sku type for the public ip | `string` | `"Basic"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `"hub"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name of the Firewall. Possible values are `AZFW_Hub` and `AZFW_VNet` | `string` | `"AZFW_VNet"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | SKU tier of the Firewall. Possible values are `Premium`, `Standard` and `Basic` | `string` | `"Standard"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | For each subnet, create an object that contain fields | <pre>map(object({<br/>    subnet_name           = string<br/>    subnet_address_prefix = list(string)<br/>    service_endpoints     = list(string)<br/>    nsg_inbound_rules     = list(list(string))<br/>    nsg_outbound_rules    = list(list(string))<br/>  }))</pre> | <pre>{<br/>  "mgnt_subnet": {<br/>    "nsg_inbound_rules": [<br/>      [<br/>        "ssh",<br/>        "100",<br/>        "Inbound",<br/>        "Allow",<br/>        "Tcp",<br/>        "22",<br/>        "*",<br/>        ""<br/>      ],<br/>      [<br/>        "rdp",<br/>        "200",<br/>        "Inbound",<br/>        "Allow",<br/>        "Tcp",<br/>        "3389",<br/>        "*",<br/>        ""<br/>      ],<br/>      [<br/>        "icmp",<br/>        "300",<br/>        "Inbound",<br/>        "Allow",<br/>        "Icmp",<br/>        "*",<br/>        "*",<br/>        ""<br/>      ],<br/>      [<br/>        "allowHTTP",<br/>        "400",<br/>        "Inbound",<br/>        "Allow",<br/>        "Tcp",<br/>        "80",<br/>        "*",<br/>        ""<br/>      ]<br/>    ],<br/>    "nsg_outbound_rules": [<br/>      [<br/>        "ntp_out",<br/>        "300",<br/>        "Outbound",<br/>        "Allow",<br/>        "Udp",<br/>        "123",<br/>        "",<br/>        "0.0.0.0/0"<br/>      ]<br/>    ],<br/>    "service_endpoints": [<br/>      "Microsoft.Storage"<br/>    ],<br/>    "subnet_address_prefix": [<br/>      "10.0.2.0/24"<br/>    ],<br/>    "subnet_name": "management"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space to be used for the Azure virtual network. | `list(any)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vpn_gateway_name"></a> [vpn\_gateway\_name](#input\_vpn\_gateway\_name) | The name of the VPN Gateway | `string` | `"vpngateway"` | no |
| <a name="input_vpn_gateway_type"></a> [vpn\_gateway\_type](#input\_vpn\_gateway\_type) | The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute | `string` | `"Vpn"` | no |
| <a name="input_vpn_gateway_vpn_type"></a> [vpn\_gateway\_vpn\_type](#input\_vpn\_gateway\_vpn\_type) | The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased | `string` | `"RouteBased"` | no |
| <a name="input_vpn_gw_sku"></a> [vpn\_gw\_sku](#input\_vpn\_gw\_sku) | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn\_type and generation arguments | `string` | `"Basic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_linux_vm"></a> [linux\_vm](#output\_linux\_vm) | Linux VM id |
| <a name="output_linux_vm_private_ip"></a> [linux\_vm\_private\_ip](#output\_linux\_vm\_private\_ip) | Linux private ip |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | The Load Balancer ID. |
| <a name="output_load_balancer_private_ip_address"></a> [load\_balancer\_private\_ip\_address](#output\_load\_balancer\_private\_ip\_address) | The private IP address assigned to the load balancer. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of IDs of subnets |
| <a name="output_tls_private_key"></a> [tls\_private\_key](#output\_tls\_private\_key) | SSH Private key |
| <a name="output_tls_public_key"></a> [tls\_public\_key](#output\_tls\_public\_key) | SSH Public key |
| <a name="output_vpn_gateway_pip"></a> [vpn\_gateway\_pip](#output\_vpn\_gateway\_pip) | VPN Gateway Public IP |
| <a name="output_windows_private_ip"></a> [windows\_private\_ip](#output\_windows\_private\_ip) | Windows private ip |
| <a name="output_windows_public_ip"></a> [windows\_public\_ip](#output\_windows\_public\_ip) | Windows public ip |
| <a name="output_windows_vm"></a> [windows\_vm](#output\_windows\_vm) | Windows VM id |
<!-- END_TF_DOCS -->

## Refernces

* [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)
* [Azure Load Balancer Decision Tree](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview)
* [Azure Private DNS Resolver Example](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-get-started-terraform?tabs=azure-cli)
* [Azure Private DNS resolver Architecture](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver)
  * [Configure DNS Forwarding for Azure Files using VMs or DNS Private Resolver](https://docs.azure.cn/en-us/storage/files/storage-files-networking-dns)
  * [Deeper dive into DNS](https://journeyofthegeek.com/2024/12/03/dns-in-microsoft-azure-private-dns-in-b2b-scenarios/)