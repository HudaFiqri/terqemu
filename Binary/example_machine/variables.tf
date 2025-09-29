variable "project_name" {
  description = "Folder name created under Virtual_Machine for this deployment."
  type        = string
  default     = "example_project"
}

variable "libvirt_uri" {
  description = "Libvirt connection URI (e.g. qemu:///system)."
  type        = string
  default     = "qemu:///system"
}

variable "vm_name" {
  description = "Name of the virtual machine."
  type        = string
  default     = "example-vm"
}

variable "memory_mb" {
  description = "Guest memory in MiB."
  type        = number
  default     = 4096
}

variable "vcpu_count" {
  description = "Number of virtual CPUs."
  type        = number
  default     = 4
}

variable "disk_size_mib" {
  description = "Optional size override for the root disk in MiB. Leave null to match the base image size."
  type        = number
  default     = null
}

variable "disk_size_gib" {
  description = "Optional size override for the root disk in GiB (takes precedence over disk_size_mib)."
  type        = number
  default     = null
}

variable "os_image_file" {
  description = "Relative or absolute path to the base OS image."
  type        = string
  default     = "../OS/example.qcow2"
}

variable "os_image_format" {
  description = "Disk format of the base OS image (qcow2, raw, etc)."
  type        = string
  default     = "qcow2"
}

variable "root_disk_format" {
  description = "Disk format for the cloned root disk."
  type        = string
  default     = "qcow2"
}

variable "cpu_mode" {
  description = "Libvirt CPU mode to use for the VM."
  type        = string
  default     = "host-passthrough"
}

variable "wait_for_lease" {
  description = "Wait for a DHCP lease on the VM interface."
  type        = bool
  default     = true
}

variable "vm_network_interfaces" {
  description = "Optional list of extra network interfaces to attach to the VM. Leave empty to use the primary network only."
  type = list(object({
    network_name   = string
    wait_for_lease = optional(bool)
    mac            = optional(string)
  }))
  default = []
}

variable "network_name" {
  description = "Name to give the libvirt network (and attach the VM to)."
  type        = string
  default     = "example-network"
}

variable "network_mode" {
  description = "Network mode (nat, bridge, routed)."
  type        = string
  default     = "nat"
}

variable "network_domain" {
  description = "Optional DNS domain served by the network."
  type        = string
  default     = "example.internal"
}

variable "network_addresses" {
  description = "CIDR blocks served by the libvirt network."
  type        = list(string)
  default     = ["192.168.125.0/24"]
}

variable "network_autostart" {
  description = "Autostart the network with libvirt."
  type        = bool
  default     = true
}

variable "network_dns_forwarders" {
  description = "Optional DNS forwarders for the network."
  type        = list(string)
  default     = []
}

variable "network_dhcp_enabled" {
  description = "Enable DHCP for the network."
  type        = bool
  default     = true
}

variable "network_dhcp_range_start" {
  description = "Optional DHCP range start address."
  type        = string
  default     = "192.168.125.10"
}

variable "network_dhcp_range_end" {
  description = "Optional DHCP range end address."
  type        = string
  default     = "192.168.125.200"
}
