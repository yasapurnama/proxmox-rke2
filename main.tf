resource "proxmox_vm_qemu" "master" {
  count = var.vm_master_count
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
  memory   = var.memory
  hotplug  = var.hotplug
  scsihw   = var.scsihw
  bootdisk = var.bootdisk


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
          size   = var.disk_size
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

}

resource "proxmox_vm_qemu" "worker" {
  count = var.vm_worker_count
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
  memory   = var.memory
  hotplug  = var.hotplug
  scsihw   = var.scsihw
  bootdisk = var.bootdisk


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
          size   = var.disk_size
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

}

resource "local_file" "inventory" {
  filename = "ansible/inventory/host.ini"
  content  = <<-EOT
[servers]
%{ for vm in proxmox_vm_qemu.master ~}
${vm.name} ansible_host=${vm.ssh_host}
%{ endfor ~}

[agents]
%{ for vm in proxmox_vm_qemu.worker ~}
${vm.name} ansible_host=${vm.ssh_host}
%{ endfor ~}

[rke2]

[rke2:children]
servers
agents

[rke2:vars]
ansible_user=${var.ssh_user}
EOT
}