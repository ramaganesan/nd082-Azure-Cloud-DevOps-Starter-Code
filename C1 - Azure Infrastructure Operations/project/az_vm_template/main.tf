##Networking Module##
module "networking" {
  source      = "./modules/networking"
  prefix   = var.prefix
  environment = var.environment
  project = var.project
  location = var.location
  debugon = var.debugon
}

##LoadBalancer Module##
module "loadbalancer" {
  source      = "./modules/loadbalancer"
  depends_on = [ module.networking]
  prefix   = var.prefix
  environment = var.environment
  project = var.project
  location = var.location
  networking = module.networking.networking-output
}

##VMConfig Module##
module "vmconfig" {
  source      = "./modules/vmconfig"
  depends_on = [ module.networking, module.loadbalancer]
  prefix   = var.prefix
  environment = var.environment
  project = var.project
  location = var.location
  vmcount = var.vmcount
  debugon = var.debugon
  networking = module.networking.networking-output
  loadbalancer = module.loadbalancer.loadbalancer-output 
}

##VMCreate Module##
module "vmcreate" {
  source      = "./modules/vmcreate"
  depends_on = [ module.networking, module.loadbalancer, module.vmconfig]
  prefix   = var.prefix
  environment = var.environment
  project = var.project
  location = var.location
  vmcount = var.vmcount
  adminusername = var.adminusername
  adminpassword = var.adminpassword
  packerimagename = var.packerimagename
  packerimagerg = var.packerimagerg
  networking = module.networking.networking-output
  vmconfig = module.vmconfig.vmconfig-output 
}


