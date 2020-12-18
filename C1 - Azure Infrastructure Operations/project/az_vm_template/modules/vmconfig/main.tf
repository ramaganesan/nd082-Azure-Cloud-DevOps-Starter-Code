//public ip for VM
resource "azurerm_public_ip" "internal" {
  count = "${var.debugon == 1 ? var.vmcount: 0}"
  name                = "${var.prefix}-vmpublicip-${count.index}"
  resource_group_name = var.networking.resource_group_name
  location            = var.networking.location
  allocation_method   = "Static"
  sku = "Standard"
  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

//Network Interface
resource "azurerm_network_interface" "internal" {
  count = var.vmcount
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = var.networking.resource_group_name
  location            = var.networking.location
  ip_configuration {
    name                          = "internal-${count.index}-ip"
    subnet_id                     = var.networking.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.debugon == 1 ? element(azurerm_public_ip.internal.*.id, count.index) : ""
  }

  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

//Network Interface and Back-end Address Pool Association
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = var.vmcount
  network_interface_id    = element(azurerm_network_interface.internal.*.id, count.index)
  ip_configuration_name   = "internal-${count.index}-ip"
  backend_address_pool_id = var.loadbalancer.backend_address_pool_id
  
}

//Network Interface and Nat Rule Association
/*resource "azurerm_network_interface_nat_rule_association" "main" {
  count = var.vmcount
  network_interface_id  = element(azurerm_network_interface.internal.*.id, count.index)
  ip_configuration_name = "internal-${count.index}-ip"
  nat_rule_id           = var.loadbalancer.nat_rule_id
}*/

//Availability Set
resource "azurerm_availability_set" "main" {
 name                         = "${var.prefix}-avset"
 location                     = var.networking.location
 resource_group_name          = var.networking.resource_group_name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
 tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

//Bastion Host Subnet
/*resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.networking.resource_group_name
  virtual_network_name = var.networking.virtual_network_name
  address_prefixes     = ["10.0.1.224/27"]
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastionhost"
  location            = var.networking.location
  resource_group_name = var.networking.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.internal.id
  }

  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}*/