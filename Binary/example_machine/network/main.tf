resource "libvirt_network" "this" {
  name      = var.network_name
  mode      = var.mode
  autostart = var.autostart

  domain    = var.domain
  addresses = var.addresses

  dynamic "dns" {
    for_each = length(var.dns_forwarders) > 0 ? [var.dns_forwarders] : []
    content {
      enabled    = true
      forwarders = dns.value
    }
  }

  dynamic "dhcp" {
    for_each = var.dhcp_enabled ? [1] : []
    content {
      enabled = true

      dynamic "range" {
        for_each = var.dhcp_range_start != null && var.dhcp_range_end != null ? [1] : []
        content {
          start = var.dhcp_range_start
          end   = var.dhcp_range_end
        }
      }
    }
  }
}

output "network_name" {
  description = "Name of the libvirt network."
  value       = libvirt_network.this.name
}
