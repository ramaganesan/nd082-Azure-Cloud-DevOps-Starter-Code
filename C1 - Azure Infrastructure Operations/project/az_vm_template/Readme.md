# Deploying a Webserver in Azure

This repo has the source code for deploying a Webserver architecture using Terraform in Azure. The following resources will be deployed in your subscription
- Resource Group
- Virtual Network
- Subnet
- NSG
- Load Balancer, LB rules, LB Health Probe, LB Public IP Address
- NIC (based on the number of VM's to be deployed)
- VM Availability Set
- VM (controlled by user supplied count). VM template is based on a Ubuntu Prebuilt image deployed in our subscription

All taggable resources will need a valid environment and project tag. This tag is enforced by a Tag Policy deployed in our subscription

---
## Modules
The code is organized into different modules to deploy different resources.

### Networking Module
This module deploys the following resources
- Resource Group
- Virtual Network
- Subnet
- NSG
  - If Debug On will create a SSH rule on port 22

### Loadbalancer Module
This module deploys the following resources
- LB Public IP
- LB 
- LB NAT Rule
- LB Health Probe

### VMConfig Module
This module deploys the following resources
- NIC (based on number of VM's)
- Network Interface and Back-end Address Pool Association
- Availability Set
- If Debug On will create public IPs for the VM's for SSH access

### VMCreate Module
This module deploys the following resources
- Managed Disk
- VM (based on number of VM's). The VM's are based on a Ubuntu Image deployed in our subscription

---
The following Variables are needed to successfully run the template
- prefix -> Prefix for our resources
- environment -> Tag resources
- project -> Tag resources
- location -> Azure Region. Defaults to "eastus"
- vmcount -> Number of VM's to be deployed. This count controls the VM's, NIC's, VM Public IP's (if debug is on)
- adminusername -> VM Admin username
- adminpassword -> VM Admin Password
- packerimagename -> Image name deployed in our subcription which is used as base image for VM's
- packerimagerg -> Image Resource Group
- debugon -> This variable controls whether we need to log into the VM's to debug the webserver output. If set to 1, this will create a NSG to allow SSH access, public IP's for the VM's so that we can log in to debug the issue inside the VM

.tfvars file has educated values for the above variables except adminusername/adminpassword which will be supplied at runtime

---
Screeshots folder has the screen shots after running the terraform deployment.