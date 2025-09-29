# Terraform + KVM Skeleton

This repository wires Terraform to QEMU/KVM through the [libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt). The folders are laid out so you can keep binary/automation code, operating system images, and generated virtual machine disks separated:

- `Binary/` – Terraform configuration and helper files. The sample stack lives under `Binary/example_machine/` and is split into `machine/` and `network/` modules.
- `OS/` – Base qcow2 images that act as templates for new VMs.
- `Virtual_Machine/` – Terraform will create a subdirectory per VM here and store the cloned disks inside it.

## Prerequisites

1. Terraform ≥ 1.5.0 installed on the host.
2. KVM/libvirt already configured locally (`libvirtd` running, `qemu:///system` accessible).
3. The libvirt Terraform provider available in your plugin cache (Terraform downloads it automatically once).
4. An OS image (qcow2) copied into the `OS/` folder.

## Usage

1. Update `Binary/example_machine/terraform.tfvars.example`, then copy it to `Binary/example_machine/terraform.tfvars` and customise the values:
- `project_name` controls the folder Terraform creates under `Virtual_Machine/`.
- `os_image_file` points to the image inside `OS/` (relative paths resolve from `Binary/example_machine/`).
- `os_image_format` / `root_disk_format` must match the actual image formats (`qcow2`, `raw`, etc.).
- `disk_size_gib` overrides the cloned disk size; fall back to `disk_size_mib` if you need MiB precision.
- `network_*` keys describe the libvirt network that will be created/managed.
- `vm_*` keys size the virtual machine and select its image.
- `vm_network_interfaces` lets you attach additional NICs (each entry points to an existing libvirt network).
2. From this repository root run:

```bash
cd Binary/example_machine
terraform init
terraform plan
terraform apply
```

Terraform will:
- Create a dedicated project directory in `Virtual_Machine/<project_name>/` and store VM disks inside it.
- Ensure a libvirt network exists with the addressing information you provided.
- Initialise a libvirt storage pool that points to the VM-specific directory.
- Clone the base image into a writable qcow2 disk.
- Boot a libvirt domain connected to the managed network.

Destroying the stack will remove the libvirt domain, volume, and storage pool. The directory under `Virtual_Machine/` is left in place so you can inspect the disk if needed.

## Notes

- The provider expects the URI `qemu:///system` by default. Export `LIBVIRT_DEFAULT_URI` if your setup differs.
- If you need cloud-init, attach ISO images, or more disks/NICs, extend `Binary/example_machine/machine/main.tf` accordingly. Multiple NICs can be listed via `vm_network_interfaces` in your `terraform.tfvars`.
- Cloud images in `.qcow2`, `.img`, or `.raw` formats are supported—just set `os_image_format` and `root_disk_format` to the matching libvirt type.
- When you swap in a new base image, run `terraform apply -replace=libvirt_volume.os_base` to rebuild downstream resources.
