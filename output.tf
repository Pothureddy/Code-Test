output "resource_group_name" {
  description = "name of the resource group"
  value       = azurerm_resource_group.rgrp.*.name"
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = "azurerm_virtual_network.vnet.*.name"
 
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = "azurerm_subnet.snet : s.id"
}

output "network_interface_private_ip" {
  description = "ip address of the VM nic"
  value = "azurerm_network_interface.vm_nic.*.private_ip_address"
}

output "network_security_group_ids" {
  description = "the name of Network security group"
  value       = "azurerm_network_security_group.vm_nsg.*.name"
}

output "server_hostname" {
  description = "hostname of the server"
  value = "azurerm_virutual_machines.vms.*.name"

}