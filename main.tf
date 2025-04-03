resource "proxmox_vm_qemu" "master" {
  count = var.vm_master_count
  vmid  = var.vmid
  name  = "${var.name}-master-${count.index}"

  target_node = var.target_node
  clone       = var.os_template
  os_type     = var.os_type
  agent       = var.agent

  define_connection_info = true
  ipconfig0 = var.ip_dhcp ? "ip=dhcp" : "ip=${var.ip_network_id}.${var.ip_network_host_master + count.index}/24,gw=${var.ip_gateway}"
  nameserver = var.ip_dhcp ? "" : var.ip_dns_nameserver

  cores    = var.cpu_cores
  sockets  = var.cpu_socket
  vcpus    = var.vcpus
  memory   = var.memory
  balloon  = var.balloon
  hotplug  = var.hotplug
  scsihw   = var.scsihw
  bootdisk = var.bootdisk
  onboot   = var.onboot
  vm_state = var.vm_state

  network {
    model    = var.network_model
    bridge   = var.network_bridge
    tag      = var.network_tag
    firewall = var.network_firewall
  }

  disks {
    virtio {
      virtio0 {
        disk {
          format  = var.disk_format
          size    = var.disk_size
          storage = var.disk_storage
          discard = var.disk_discard
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      vmid,
      ciuser,
      sshkeys
    ]
  }

}

resource "proxmox_vm_qemu" "worker" {
  count = var.vm_worker_count
  vmid  = var.vmid
  name  = "${var.name}-worker-${count.index}"

  target_node = var.target_node
  clone       = var.os_template
  os_type     = var.os_type
  agent       = var.agent

  define_connection_info = true
  ipconfig0 = var.ip_dhcp ? "ip=dhcp" : "ip=${var.ip_network_id}.${var.ip_network_host_worker + count.index}/24,gw=${var.ip_gateway}"
  nameserver = var.ip_dhcp ? "" : var.ip_dns_nameserver

  cores    = var.cpu_cores
  sockets  = var.cpu_socket
  vcpus    = var.vcpus
  memory   = var.memory
  balloon  = var.balloon
  hotplug  = var.hotplug
  scsihw   = var.scsihw
  bootdisk = var.bootdisk
  onboot   = var.onboot
  vm_state = var.vm_state

  network {
    model    = var.network_model
    bridge   = var.network_bridge
    tag      = var.network_tag
    firewall = var.network_firewall
  }

  disks {
    virtio {
      virtio0 {
        disk {
          format  = var.disk_format
          size    = var.disk_size
          storage = var.disk_storage
          discard = var.disk_discard
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      vmid,
      ciuser,
      sshkeys
    ]
  }

}

resource "local_file" "inventory" {
  filename = "ansible/inventory/hosts.ini"
  content  = <<-EOT
[servers]
%{ for key, vm in proxmox_vm_qemu.master ~}
server${key+1} ansible_host=${vm.ssh_host}
%{ endfor ~}

[agents]
%{ for key, vm in proxmox_vm_qemu.worker ~}
agent${key+1} ansible_host=${vm.ssh_host}
%{ endfor ~}

[rke2]

[rke2:children]
servers
agents

[rke2:vars]
ansible_user=${var.ssh_user}
EOT
}
