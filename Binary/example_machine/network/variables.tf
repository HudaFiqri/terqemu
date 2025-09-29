variable "network_name" {
  description = "Name of the libvirt network to manage."
  type        = string
}

variable "mode" {
  description = "Network mode (e.g. nat, bridge, routed)."
  type        = string
  default     = "nat"
}

variable "domain" {
  description = "Optional DNS domain for the network."
  type        = string
  default     = null
}

variable "addresses" {
  description = "CIDR blocks assigned to the network."
  type        = list(string)
}

variable "autostart" {
  description = "Whether the network should autostart with libvirt."
  type        = bool
  default     = true
}

variable "dns_forwarders" {
  description = "Optional list of DNS forwarders to configure."
  type        = list(string)
  default     = []
}

variable "dhcp_enabled" {
  description = "Enable the built-in DHCP server for the network."
  type        = bool
  default     = true
}

variable "dhcp_range_start" {
  description = "Optional start address for DHCP range."
  type        = string
  default     = null
}

variable "dhcp_range_end" {
  description = "Optional end address for DHCP range."
  type        = string
  default     = null
}
