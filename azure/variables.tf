variable "resource_group" {
  description = "The name of the resource group in which to create the resources."
  default = "CloCareRG"
}

variable "env" {
  description = "The name of the enviroment tag."
  default = "CloCare"
}

variable "location" {
  description = "The location/region where the resources are created."
  default     = "uksouth"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.0.0/24"
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "CloCareNetwork"
}

# Controller VM Variables
variable "controller_vm_name" {
  description = "VM name referenced also in storage-related names."
  default = "controller_vm"
}

variable "controller_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "controller_vm_private_ip" {
  description = "Specifies the private ip of the virtual machine."
  default     = "10.0.0.10"
}

# Compute1 VM Variables
variable "compute1_vm_name" {
  description = "VM name referenced also in storage-related names."
  default = "compute1_vm"
}

variable "compute1_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "compute1_vm_private_ip" {
  description = "Specifies the private ip of the virtual machine."
  default     = "10.0.0.11"
}

# Compute2 VM Variables
variable "compute2_vm_name" {
  description = "VM name referenced also in storage-related names."
  default = "compute2_vm"
}

variable "compute2_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_DS1_v2"
}

variable "compute2_vm_private_ip" {
  description = "Specifies the private ip of the virtual machine."
  default     = "10.0.0.12"
}

# Storage VM Variables
variable "storage_vm_name" {
  description = "VM name referenced also in storage-related names."
  default = "storage_vm"
}

variable "storage_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_DS1_v2"
}

variable "storage_vm_private_ip" {
  description = "Specifies the private ip of the virtual machine."
  default     = "10.0.0.13"
}