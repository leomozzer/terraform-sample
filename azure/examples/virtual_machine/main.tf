resource "azurerm_resource_group" "vmrg" {
  count = var.prod == true ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "azvn" {
  count = var.prod == true ? 1 : 0
  name = "${var.prefix}-network"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.vmrg[count.index].location
  resource_group_name = azurerm_resource_group.vmrg[count.index].name
}

resource "azurerm_subnet" "internal" {
  count = var.prod == true ? 1 : 0
  name = "internal"
  resource_group_name = azurerm_resource_group.vmrg[count.index].name
  virtual_network_name = azurerm_virtual_network.azvn[count.index].name
  address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_network_interface" "main" {
  count = var.prod == true ? 1 : 0
  name = "${var.prefix}-nic"
  location = var.location
  resource_group_name = azurerm_resource_group.vmrg[count.index].name
  ip_configuration {
    name = "testconfiguration1"
    subnet_id = azurerm_subnet.internal[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  count = var.prod == true ? 1 : 0
  name = "${var.prefix}-vm"
  location = azurerm_resource_group.vmrg[count.index].location
  resource_group_name = azurerm_resource_group.vmrg[count.index].name
  network_interface_ids = [ azurerm_network_interface.main[count.index].id ]
  vm_size = "Standard_DS1_V2"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }
  storage_os_disk {
    name = "myosdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    "environmet" = "staging"
  }
}

resource "azurerm_managed_disk" "newdisk" {
  count = var.newdisc == true ? 1 : 0
  name = "${var.prefix}-newdisk01"
  location = var.location
  resource_group_name = azurerm_resource_group.vmrg[count.index].name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 5
}

resource "azurerm_virtual_machine_data_disk_attachment" "newvmdisk" {
  count = var.newdisc == true ? 1 : 0
  managed_disk_id = azurerm_managed_disk.newdisk[count.index].id
  virtual_machine_id = azurerm_virtual_machine.main[count.index].id
  lun = "10"
  caching = "ReadWrite"
}