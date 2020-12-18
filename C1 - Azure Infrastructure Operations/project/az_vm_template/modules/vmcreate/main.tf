resource "azurerm_managed_disk" "datadisk" {
 count                = var.vmcount
 name                 = "${var.prefix}-datadisk-${count.index}"
 location             = var.networking.location
 resource_group_name  = var.networking.resource_group_name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
 tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}
data "azurerm_resource_group" "image" {
  name = var.packerimagerg
}
data "azurerm_image" "image" {
  name                = var.packerimagename
  resource_group_name = data.azurerm_resource_group.image.name
}

resource "azurerm_virtual_machine" "vminternal" {
 count                 = var.vmcount
 name                  = "${var.prefix}-vm-${count.index}"
 location              = var.networking.location
 availability_set_id   = var.vmconfig.availability_set_id
 resource_group_name   = var.networking.resource_group_name
 network_interface_ids = [element(var.vmconfig.network_interface_ids.*.id,count.index)]
 vm_size               = "Standard_DS1_v2"

 delete_os_disk_on_termination = true

 delete_data_disks_on_termination = true

 storage_image_reference {
   id = data.azurerm_image.image.id
 }

 storage_os_disk {
   name              = "${var.prefix}-osdisk-${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_data_disk {
   name            = element(azurerm_managed_disk.datadisk.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.datadisk.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.datadisk.*.disk_size_gb, count.index)
 }

 os_profile {
   computer_name  = "${var.prefix}-vm"
   admin_username = var.adminusername
   admin_password = var.adminpassword
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

resource "azurerm_virtual_machine_extension" "internal" {
  count                 = var.vmcount
  name                  = "${var.prefix}-vmextension-${count.index}"
  virtual_machine_id   = element(azurerm_virtual_machine.vminternal.*.id, count.index)
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo nohup busybox httpd -f -p 80 -h /home/packer -&"
    }
SETTINGS


  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}