#!/bin/bash

if [[ ! $(dpkg -s libguestfs-tools) ]]; then
  apt update
  apt install -y libguestfs-tools
fi

# set variables
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE="noble-server-cloudimg-amd64.img"
OS_TYPE="l26"
TEMPLATE_NAME="ubuntu-24.04-cloudinit"
VM_ID="9000"
MEMORY="1024"
CPU="1"
VGA="qxl"
DISK_STOR="local-lvm"
NET_BRIDGE="vmbr0"
USER="ubuntu"
PASSWORD=$(openssl rand -base64 14)
SSH_KEY="/root/.ssh/id_rsa.pub"


if [[ $(cat /etc/pve/.vmlist ) == *"\"$VM_ID\""* ]]; then
  echo -e "\033[0;31mVM with ID $VM_ID already exists\033[0m"
  exit 1
fi

if [ ! -f $IMAGE ]; then
  wget $IMAGE_URL -O $IMAGE
fi


mkdir -p /mnt/customize_image
guestmount -a $IMAGE -i --rw /mnt/customize_image
cd /mnt/customize_image/var/lib/systemd/
if [ ! -f random-seed ]; then
  dd if=/dev/urandom of=random-seed bs=512 count=4
  chmod 755 random-seed
fi
cd -
guestunmount /mnt/customize_image/

virt-customize -a $IMAGE --install qemu-guest-agent --truncate /etc/machine-id

qm create $VM_ID --name $TEMPLATE_NAME --memory $MEMORY --net0 virtio,bridge=$NET_BRIDGE --cpu host --sockets 1 --cores $CPU

qm importdisk $VM_ID $IMAGE $DISK_STOR

qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 $DISK_STOR:vm-$VM_ID-disk-0 --serial0 socket
qm set $VM_ID --boot c --bootdisk virtio0 --ostype $OS_TYPE --agent 1 --hotplug disk,network,usb
qm set $VM_ID --vcpus 1 --vga $VGA --ide2 $DISK_STOR:cloudinit --vmgenid 1 --ipconfig0 ip=dhcp
qm set $VM_ID --ciuser $USER --cipassword $PASSWORD --sshkeys $SSH_KEY

qm template $VM_ID

echo -e "\n\033[0;32m=============================\033[0m"
echo -e "\033[0;32mVM with ID $VM_ID created\033[0m"
echo -e "\033[0;32mVM name: $TEMPLATE_NAME\033[0m"
echo -e "\033[0;32mUsername: $USER\033[0m"
echo -e "\033[0;32mPassword: $PASSWORD\033[0m"
echo -e "\033[0;32mTemplate image: $IMAGE\033[0m"
echo -e "\033[0;32mTemplate image checksum: $(sha256sum $IMAGE)\033[0m"
echo -e "\033[0;32mTemplate image size: $(du -h $IMAGE | awk '{print $1}')\033[0m"
echo -e "\033[0;32m=============================\033[0m"
