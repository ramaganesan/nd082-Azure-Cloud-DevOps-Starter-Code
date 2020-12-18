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

---
To run the templates
- Templates require terraform version 0.12 or greater and azure provider 2.40.0 or greater. If running on a different version, please modify the versions.tf
- Edit the .tfvars file to provide valid values
- Make sure you have pre determined adminusername and adminpassword. These values are supplied at runtime and once the VM's are created this is the only way to log into the machine
- If you set debugon to 1, then the template will create a public IP's for the VM's,it will also create a NSG to allow SSH access. This will allow the user to login to the VM's to debug issues. 

`terraform init`
  Above command will initialize Azure Provider. 

`terraform plan or terraform plan -out nd081-project1.plan`
  Above command will create a in memory plan for template.

`terraform apply or terraform apply nd081-project1.plan`
  Above command will apply the plan and create resources in your subscription