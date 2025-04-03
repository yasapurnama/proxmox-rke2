variable "pm_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "pm_user" {
  description = "The username to authenticate with the Proxmox API"
  type        = string
}

variable "pm_password" {
  description = "The password to authenticate with the Proxmox API"
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_master_count" {
  description = "The number of Master VMs to create"
  type        = number
  default     = 1
}

variable "vm_worker_count" {
  description = "The number of Worker VMs to create"
  type        = number
  default     = 1
}

variable "vmid" {
  description = "The VM ID to create"
  type        = number
  default     = 0
}

variable "name" {
  description = "The name of the VMs to create"
  type        = string
  default     = "vm"
}

variable "target_node" {
  description = "The target node to create the VMs on"
  type        = string
  default     = "pve"
}

variable "os_template" {
  description = "The OS template to clone the VMs from"
  type        = string
}

variable "os_type" {
  description = "The OS type of the VMs"
  type        = string
  default     = "cloud-init"
}

variable "agent" {
  description = "Whether to install the QEMU agent on the VMs"
  type        = number
  default     = 1
}

variable "ip_dhcp" {
  description = "Whether to use DHCP for the VMs"
  type        = bool
  default     = true
}

variable "ip_network_id" {
  description = "The first three blocks of the IP address"
  type        = string
  default     = "192.168.1"
}

variable "ip_network_host" {
  description = "The starting value of the last block of the IP address"
  type        = number
  default     = 100
}

variable "ip_network_host_master" {
  description = "The starting value of the last block of the IP address for the Master VMs"
  type        = number
  default     = 100
}

variable "ip_network_host_worker" {
  description = "The starting value of the last block of the IP address for the Worker VMs"
  type        = number
  default     = 200
}

variable "ip_gateway" {
  description = "The gateway IP address"
  type        = string
  default     = "192.168.1.1"
}

variable "ip_dns_nameserver" {
  description = "The DNS IP address"
  type        = string
  default     = "8.8.8.8"
}

variable "cpu_cores" {
  description = "The number of CPU cores for the VMs"
  type        = number
  default     = 2
}

variable "cpu_socket" {
  description = "The number of CPU sockets for the VMs"
  type        = number
  default     = 1
}

variable "vcpus" {
  description = "The number of vCPUs for the VMs"
  type        = number
  default     = 2
}

variable "memory" {
  description = "The amount of memory in MB for the VMs"
  type        = number
  default     = 2048
}

variable "balloon" {
  description = "The balloon memory for the VMs"
  type        = number
  default     = 0
}

variable "hotplug" {
  description = "The hotplug devices for the VMs"
  type        = string
  default     = "disk,usb,network"
}

variable "scsihw" {
  description = "The SCSI hardware for the VMs"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "bootdisk" {
  description = "The boot disk for the VMs"
  type        = string
  default     = "virtio0"
}

variable "onboot" {
  description = "Whether to start the VMs on boot"
  type        = bool
  default     = true
}

variable "vm_state" {
  description = "The state of the VMs"
  type        = string
  default     = "running"
}

variable "network_model" {
  description = "The network model for the VMs"
  type        = string
  default     = "virtio"
}

variable "network_bridge" {
  description = "The network bridge for the VMs"
  type        = string
  default     = "vmbr0"
}

variable "network_tag" {
  description = "The network tag for the VMs"
  type        = number
  default     = 0
}

variable "network_firewall" {
  description = "The network firewall for the VMs"
  type        = bool
  default     = false
}

variable "disk_format" {
  description = "The format of disk for the VMs"
  type        = string
  default     = "qcow2"
}

variable "disk_size" {
  description = "The size of the disk in GB for the VMs"
  type        = number
  default     = 20
}

variable "disk_storage" {
  description = "The name of the disk storage to use for the VMs"
  type        = string
  default     = "local-lvm"
}

variable "disk_discard" {
  description = "The discard behavior for the disk"
  type        = bool
}

variable "ssh_user" {
  description = "The SSH user to connect to the VMs"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "The SSH private key to connect to the VMs"
  type        = string
  default     = "~/.ssh/id_rsa"
}
