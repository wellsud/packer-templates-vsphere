#cloud-config
autoinstall:
    version: 1
    early-commands:
        # workaround to stop ssh for packer as it thinks it timed out
        - sudo systemctl stop ssh
    locale: ${vm_guest_os_language}
    keyboard:
        layout: ${vm_guest_os_keyboard}
        
    packages: [open-vm-tools, openssh-server, perl, open-iscsi, curl, nano]
    
    network:
      network:
        version: 2
        ethernets:
          ens192:
           addresses: [${vm_ip_address}]
           gateway4: ${vm_gateway}
           nameservers:
             addresses: [${primary_dns},${secondary_dns}]
    
    ntp:
      enabled: true
      ntp_client: chrony
    
    identity:
        hostname: ${vm_name}
        username: ${ubuntu_username}
        password: ${ubuntu_password}
    ssh:
        install-server: yes
        allow-pw: yes
        authorized-keys:
          - ${pub_key}
    
    swap:
      size: 0    

    storage:
      version: 1
      config:
        - id: sda
          type: disk
          ptable: gpt
          path: /dev/sda
          name: main_disk
          grub_device: true
        - id: bios_boot_partition
          type: partition
          size: 1MB
          device: sda
          flag: bios_grub
        - id: boot_part
          type: partition
          size: 8G
          device: sda
          flag: boot
        - id: lvm_part
          type: partition
          size: -1
          device: sda
        - id: volgroup1
          name: volgroup1
          type: lvm_volgroup
          devices:
              - lvm_part
        - id: root_part
          name: root_part
          size: 35G
          type: lvm_partition
          volgroup: volgroup1
        - id: var_part
          name: lv2_var
          type: lvm_partition
          volgroup: volgroup1
        - id: boot_fs
          type: format
          fstype: ext4
          volume: boot_part
        - id: root_fs
          name: storage
          type: format
          fstype: ext4
          volume: root_part
        - id: var_fs
          name: storage
          type: format
          fstype: ext4
          volume: var_part
        - id: boot_mount
          type: mount
          path: /boot
          device: boot_fs
        - id: root_mount
          type: mount
          path: /
          device: root_fs
        - id: var_mount
          type: mount
          path: /var
          device: var_fs
          
           
    
    
    timezone: ${vm_guest_os_timezone}   
    user-data:
        disable_root: false
        package_update: true
        package_upgrade: true
        package_reboot_if_required: true
        
    late-commands:
        - echo '${ubuntu_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${ubuntu_username}
        - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${ubuntu_username}