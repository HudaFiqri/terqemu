terraform {
  required_version = ">= 1.5.0"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

locals {
  project_directory = abspath("${path.module}/../../Virtual_Machine/${var.project_name}")
  os_image_path     = startswith(var.os_image_file, "/") ? var.os_image_file : abspath("${path.module}/${var.os_image_file}")
  vm_network_interfaces = length(var.vm_network_interfaces) > 0 ? var.vm_network_interfaces : [
    {
      network_name   = var.network_name
      wait_for_lease = var.wait_for_lease
    }
  ]
}

resource "null_resource" "project_directory" {
  triggers = {
    path = local.project_directory
  }

  provisioner "local-exec" {
    command = "mkdir -p '${local.project_directory}'"
  }
}

module "network" {
  source = "./network"

  network_name      = var.network_name
  mode              = var.network_mode
  domain            = var.network_domain
  addresses         = var.network_addresses
  autostart         = var.network_autostart
  dns_forwarders    = var.network_dns_forwarders
  dhcp_enabled      = var.network_dhcp_enabled
  dhcp_range_start  = var.network_dhcp_range_start
  dhcp_range_end    = var.network_dhcp_range_end

  depends_on = [null_resource.project_directory]
}

module "machine" {
  source = "./machine"

  project_directory = local.project_directory
  vm_name           = var.vm_name
  memory_mb         = var.memory_mb
  vcpu_count        = var.vcpu_count
  disk_size_mib     = var.disk_size_mib
  disk_size_gib     = var.disk_size_gib
  os_image_path     = local.os_image_path
  os_image_format   = var.os_image_format
  root_disk_format  = var.root_disk_format
  cpu_mode          = var.cpu_mode
  wait_for_lease    = var.wait_for_lease
  network_interfaces = [
    for iface in local.vm_network_interfaces : {
      network_name   = iface.network_name
      wait_for_lease = try(iface.wait_for_lease, null)
      mac            = try(iface.mac, null)
    }
  ]

  depends_on = [module.network]
}

output "project_directory" {
  description = "Base directory under Virtual_Machine where this project stores assets."
  value       = local.project_directory
}

output "network_name" {
  description = "Libvirt network created or managed by this configuration."
  value       = module.network.network_name
}

output "vm_id" {
  description = "Unique ID of the created libvirt domain."
  value       = module.machine.vm_id
}

output "vm_directory" {
  description = "Directory on the host where the VM disk is stored."
  value       = module.machine.vm_directory
}
