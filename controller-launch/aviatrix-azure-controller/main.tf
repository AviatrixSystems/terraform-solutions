provider "azurerm" {
  version = "~> 2.2"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_public_ip" "example" {
  name                    = "avx-controller-public-ip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.env_tag
  }
}

resource "azurerm_network_interface" "example" {
  name                = "avx-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "avx-controller-nic"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "null_resource" "accept_license" {
   provisioner "local-exec" {
       command = "python3 ./accept_license.py"
   }
}


resource "azurerm_virtual_machine" "test" {
  name                  = "AviatrixController"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = ["${azurerm_network_interface.example.id}"]
  vm_size               = "Standard_A4_v2"

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "aviatrix-systems"
    offer     = "aviatrix-bundle-payg"
    sku       = "aviatrix-enterprise-bundle-byol"
    version   = "latest"
  }

  plan {
    name = "aviatrix-enterprise-bundle-byol"
    publisher = "aviatrix-systems"
    product = "aviatrix-bundle-payg"
  }

  storage_os_disk {
    name              = "avxdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "avx-controller"
    admin_username = "avx2020"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }


}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.0.0/24"]
  subnet_names        = ["avx-ctrl-sub1"]
  vnet_name           = "avx-controller-vnet"

  tags = {
    environment = var.env_tag
    terraform_created  = "true"
  }
}

module "network-security-group" {
  source              = "Azure/network-security-group/azurerm//modules/HTTPS"
  resource_group_name = azurerm_resource_group.main.name
  security_group_name = "nsg"
  custom_rules = [
    {
      name                   = "ssh"
      priority               = "200"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "22"
      source_address_prefix  = "10.0.0.0/24"
      description            = "ssh-for-vm-management"
    }
  ]
  tags = {
    environment = var.env_tag
    terraform_created = "true"
  }
}

data "azurerm_public_ip" "example" {
  name                = azurerm_public_ip.example.name
  resource_group_name = azurerm_virtual_machine.test.resource_group_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.example.ip_address
}

output "aviatrix_controller_private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}