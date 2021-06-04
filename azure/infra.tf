# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "= 2.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = var.resource_group
    location = var.location

    tags = {
        environment = var.env
    }
}
output "rg_name" { value = azurerm_resource_group.myterraformgroup.name }

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = var.virtual_network_name
    address_space       = [var.address_space]
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = var.env
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "${var.virtual_network_name}Subnet1"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = [var.subnet_prefix]
}
output "subnet_prefix" { value = var.subnet_prefix }

# Create an SSH key
resource "tls_private_key" "myterraformsshkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Store private key localy
resource "local_file" "myterraformprivatekey" {
    content  = tls_private_key.myterraformsshkey.private_key_pem
    filename = "../ansible/private_key.pem"
}

# Create Controller VM  
# Create public IPs
resource "azurerm_public_ip" "controllervmpublicip" {
    name                         = "${var.controller_vm_name}PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.env
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "controllervmsg" {
    name                = "${var.controller_vm_name}SecurityGroup"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "http/s"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["80","443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "openstack"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["5000","2379-2380","9311","8774-8778","9292","11211","8000","8004","9511","9696","6080"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "cockpit"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9090"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.env
    }
}

# Create network interface
resource "azurerm_network_interface" "controllervmnic" {
    name                      = "${var.controller_vm_name}NIC"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "${var.controller_vm_name}NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = var.controller_vm_private_ip
        public_ip_address_id          = azurerm_public_ip.controllervmpublicip.id
    }

    tags = {
        environment = var.env
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "controllervmass" {
    network_interface_id      = azurerm_network_interface.controllervmnic.id
    network_security_group_id = azurerm_network_security_group.controllervmsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "controllervm" {
    name                  = var.controller_vm_name
    location              = var.location
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.controllervmnic.id]
    size                  = var.controller_vm_size

    os_disk {
        name              = "${var.controller_vm_name}OsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
    } 

    computer_name  = "controller"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.myterraformsshkey.public_key_openssh
    }

    tags = {
        environment = var.env
    }
}
output "controller_vm_name" { value = azurerm_linux_virtual_machine.controllervm.name }
output "controller_vm_private_ip" { value = var.controller_vm_private_ip}

# Create Compute1 VM  
# Create public IPs
resource "azurerm_public_ip" "compute1vmpublicip" {
    name                         = "${var.compute1_vm_name}PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.env
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "compute1vmsg" {
    name                = "${var.compute1_vm_name}SecurityGroup"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "cockpit"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9090"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
 
    tags = {
        environment = var.env
    }
}

# Create network interface
resource "azurerm_network_interface" "compute1vmnic" {
    name                      = "${var.compute1_vm_name}NIC"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "${var.compute1_vm_name}NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = var.compute1_vm_private_ip
        public_ip_address_id          = azurerm_public_ip.compute1vmpublicip.id
    }

    tags = {
        environment = var.env
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "compute1vmass" {
    network_interface_id      = azurerm_network_interface.compute1vmnic.id
    network_security_group_id = azurerm_network_security_group.compute1vmsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "compute1vm" {
    name                  = var.compute1_vm_name
    location              = var.location
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.compute1vmnic.id]
    size                  = var.compute1_vm_size

    os_disk {
        name              = "${var.compute1_vm_name}OsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
    } 

    computer_name  = "compute1"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.myterraformsshkey.public_key_openssh
    }

    tags = {
        environment = var.env
    }
}
output "compute1_vm_name" { value = azurerm_linux_virtual_machine.compute1vm.name }
output "compute1_vm_private_ip" { value = var.compute1_vm_private_ip}