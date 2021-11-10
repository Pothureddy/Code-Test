# Create a Resource Group

resource "azurerm_resource_group_name" "rgrp" {
  name = "vm_rgrp"
  location  = "var.location"  
}
resource "azurerm_storage_account" "storage" {
  name                     = "var.storage_account_name"
  resource_group_name      = azurerm_resource_group.rgrp.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}

# Create a Virtual network

resource "azurerm_virtual_network" "vnet" {
  name                = "vm_vnet"
  resource_group_name = azurerm_resource_group.rgrp.name
  location            = var.location
  address_space       = var.address_space
}

#create a subnet

resource "azurerm_subnet" "subnet" {
  name = "vm_subnet"
  count = "2"
  virtual_network_name = ""
  resource_group_name = ""
  address_prefixes = "var.address_prefixes"
  
}

#Create a Networksecurity group

resource "azurerm_network_security_group" "nsg" {
  name = "vm_nsg"
  location = "var.location"
  resource_group_name = "azurerm_resource_group.rgrp.name"
}

#Create a Network security rules

resource "azurerm_network_security_rule" "nsgrule" {
  name = vm_nsg
  prority = tonumber(100 * (count.index +1 ))
  direction = "Inbound"
  access = "allow"
  protocal = "TCP"
  source_port_range = "80,443"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group_name.rgrp.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurrrm_network_interface" "nic" {
  name = "vm_nic" 
  resource_group_name = azurerm_resource_group_name.rgrp.name
  location = var.location
  
  ip_configuration {
   name = var.ipconfig
   subnet_id = azurerm_subnet.subnet.name
   private_ip_allocation = "Dynamic"
  }
 }
 
data "azurerm_key_vault_secret" "example" {
  name         = "secret-sauce"
  key_vault_id = data.azurerm_key_vault.existing.id
}
 
resource "random_password" "vmpassword" {
  length = 20
  special = true
}
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.password
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on = [ azurerm_key_vault.kv1 ]
}
 
resource "azurerm_virtual_machine" "vm"
  name = var.hostname
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_id = azurerm_network_interface.nic.*.id
  vm_size = var.vm_size
  
  delete_os_disk_on_termination = true
  
  delete_data_disk_on_termination = true
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
	offer = "WindowsServer"
	sku = "2016-Datacenter"
	version = "latest"
  }
  storage_os_disk {
    name = var.os_disk
	caching = "ReadWrite"
	create_option = "FromImage"
	Managed_disk_type = "Standard_LRS"
 }
 storage_data_disk {
   name = var_data_disk
   managed_data_disk = "Standard_LRS"
   create_option = "Empty"
   disk_size_gb = var_add_disk
   lun = 0
  }
  os_profile {
    computer_name = var.hostname
	admin_username = var.admin_username
	admin_password = azurerm_key_vault_secret.vmpassword.value
  }
 }