//public ip
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-lb-publicip"
  resource_group_name = var.networking.resource_group_name
  location            = var.networking.location
  allocation_method   = "Static"
  sku = "Standard"
  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

//Load Balancer
resource "azurerm_lb" "main" {
 name                = "${var.prefix}-lb"
 location            = var.networking.location
 resource_group_name = var.networking.resource_group_name
 sku = "Standard"

 frontend_ip_configuration {
   name                 = "${var.prefix}-primary"
   public_ip_address_id = azurerm_public_ip.main.id
 }

 tags = {
    environment = "${var.environment}"
    project = "${var.project}"
  }
}

resource "azurerm_lb_backend_address_pool" "internal" {
 resource_group_name = var.networking.resource_group_name
 loadbalancer_id     = azurerm_lb.main.id
 name                = "${var.prefix}-BackEndAddressPool"
}

/*resource "azurerm_lb_nat_rule" "internal" {
  resource_group_name            = var.networking.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "HttpAccess"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.prefix}-primary"
}*/
resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = var.networking.resource_group_name
   loadbalancer_id                = azurerm_lb.main.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.internal.id
   frontend_ip_configuration_name = "${var.prefix}-primary"
   probe_id                       = azurerm_lb_probe.lbprobe.id
}

resource "azurerm_lb_probe" "lbprobe" {
  resource_group_name = var.networking.resource_group_name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "tcp-running-probe"
  port                = 80
  number_of_probes = 4

}