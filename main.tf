# Configure the VirtualBox provider
provider "virtualbox" {
  version = ">= 0.4.0"
}

# Create a NAT network for the VM
resource "virtualbox_nat_network" "nat_network" {
  name   = "nat-network"
  enable = true

  # Optional settings for the NAT network
  ipv4_network = "192.168.56.0/24"  # Specify the network range
  ipv4_gateway = "192.168.56.1"
  dhcp        = true  # Enable DHCP to assign IPs automatically
}

# Define a VirtualBox virtual machine
resource "virtualbox_vm" "secure_vm" {
  name    = "secure-local-vm"
  image   = "ubuntu-22.04.5-desktop-amd64.iso"  # Path to the ISO image
  cpus    = 2
  memory  = 4096  # Memory in MB
  boot_order = ["dvd", "hd"]

  # Attach a network adapter connected to the NAT network
  network_interface {
    type             = "nat"
    network_name     = virtualbox_nat_network.nat_network.name
  }

  disk {
    size = 10240  # Disk size in MB
  }

  secure_boot = true  # Enable secure boot for enhanced security

  # Optional: Enable TPM for secure boot operations
  tpm {
    version = "2.0"
  }
}

# Attach the ISO image as a CD/DVD drive
resource "virtualbox_cdrom" "iso" {
  vm_id   = virtualbox_vm.secure_vm.id
  image   = "C:\\Users\\Anubhav\\Downloads\\ubuntu-22.04.5-desktop-amd64.iso"
}
