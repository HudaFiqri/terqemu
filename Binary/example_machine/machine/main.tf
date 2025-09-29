locals {
  vm_directory = abspath("${var.project_directory}/${var.vm_name}")
  root_disk_size_bytes = var.disk_size_gib != null ?
    var.disk_size_gib * 1024 * 1024 * 1024 :
    (var.disk_size_mib != null ? var.disk_size_mib * 1024 * 1024 : null)
}

resource "null_resource" "vm_directory" {
  triggers = {
    vm_directory = local.vm_directory
  }

  provisioner "local-exec" {
    command = "mkdir -p '${local.vm_directory}'"
  }
}

resource "libvirt_pool" "vm_pool" {
  name = "${var.vm_name}_pool"
  type = "dir"
  path = local.vm_directory

  depends_on = [null_resource.vm_directory]
}

resource "libvirt_volume" "os_base" {
  name = "${var.vm_name}-base"
  pool = libvirt_pool.vm_pool.name
  source = var.os_image_path
  format = var.os_image_format
}

resource "libvirt_volume" "root_disk" {
  name           = "${var.vm_name}.${var.root_disk_format}"
  pool           = libvirt_pool.vm_pool.name
  base_volume_id = libvirt_volume.os_base.id
  format         = var.root_disk_format
  size           = local.root_disk_size_bytes
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory_mb
  vcpu   = var.vcpu_count

  cpu {
    mode = var.cpu_mode
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      network_name   = network_interface.value.network_name
      wait_for_lease = coalesce(lookup(network_interface.value, "wait_for_lease", null), var.wait_for_lease)
      mac            = try(network_interface.value.mac, null)
    }
  }

  disk {
    volume_id = libvirt_volume.root_disk.id
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  depends_on = [libvirt_volume.root_disk]
}

output "vm_id" {
  description = "Unique ID of the created libvirt domain."
  value       = libvirt_domain.vm.id
}

output "vm_directory" {
  description = "Directory on the host where the VM disk is stored."
  value       = local.vm_directory
}
