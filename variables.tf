variable "tenant_id" {
}
variable "subsciption_id" {
}
variable "client_id" {
}
variable "client_secret" {
}
variable "resource_group_name" {
    name = rgrp
}
variable "subnet" {
}
variable "vnet_name" {
}
variable "vnet_rg" {
}
variable "location" {
  type = string
  default = northeurope
}
variable "nsg_rule" {
  type = bool
  default true
}
variable "nsg_range" {
 type = list
 default = [ "80", "443"]
}
variable "vm_size" {
  type = string
  default = "Standard_D4s_V4"
}
variable "add_disk" {
  default = 128
}
variable "storage_account" {
  name = storage
}
variable "azure_keyvault" {
   name = keyvault
}

 