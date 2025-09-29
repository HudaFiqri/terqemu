variable "project_directory" {
  description = "Absolute path to the project directory under Virtual_Machine."
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine and associated libvirt resources."
  type        = string
}

variable "memory_mb" {
  description = "Guest memory in MiB."
  type        = number
}

variable "vcpu_count" {
  description = "Number of virtual CPUs assigned to the guest."
  type        = number
}

variable "disk_size_mib" {
  description = "Optional size for the root disk in MiB. Leave null to keep the base image size."
  type        = number
  default     = null
}

variable "disk_size_gib" {
  description = "Optional size for the root disk in GiB. Takes precedence over disk_size_mib when set."
  type        = number
  default     = null
}

variable "os_image_path" {
  description = "Absolute path to the disk image that serves as the base OS."
  type        = string
}

variable "os_image_format" {
  description = "Disk format of the base OS image (e.g. qcow2, raw)."
  type        = string
  default     = "qcow2"
}

variable "root_disk_format" {
  description = "Disk format for the cloned root disk (defaults to qcow2)."
  type        = string
  default     = "qcow2"
}

variable "cpu_mode" {
  description = "Libvirt CPU mode to use. Most setups can keep host-passthrough for best performance."
  type        = string
  default     = "host-passthrough"
}

variable "wait_for_lease" {
  description = "Whether Terraform should wait for the DHCP lease on the primary network interface."
  type        = bool
  default     = true
}

variable "network_interfaces" {
  description = "List of network interfaces to attach to the VM."
  type = list(object({
    network_name   = string
    wait_for_lease = optional(bool)
    mac            = optional(string)
  }))
}
