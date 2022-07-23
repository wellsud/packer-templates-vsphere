// Variaveis locais
// timestamp obtem o dia e a hora atual
// user-data forma o arquivo de dados para o autoconfig a partir do template 
//user-data.pkrtpl.hcl alimentado pelas variáveis customizadas


locals { 
  timestamp = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  user-data = templatefile("${abspath(path.root)}/http/user-data.pkrtpl.hcl", {
    vm_name = var.vm_name
    ubuntu_username = var.ubuntu_username,
    ubuntu_password = var.ubuntu_password,
    pub_key = var.pub_key,
    vm_guest_os_language = var.vm_guest_os_language, 
    vm_guest_os_keyboard = var.vm_guest_os_keyboard, 
    vm_guest_os_timezone = var.vm_guest_os_timezone,
    vm_ip_address = var.vm_ip_address,
    vm_gateway = var.vm_gateway,
    primary_dns = var.primary_dns
    secondary_dns = var.secondary_dns
  
  })
}

// Módulos necessários

packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vsphere = {
      version = " >= v1.0.3"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}


source "vsphere-iso" "ubuntu-20-04-amd64-server" {
// Conexão com o servidor vSphere
  username       = var.vcenter_username
  vcenter_server = var.vcenter_server

// Criação da maquina virtual
  vm_name        = var.vm_name
  CPUs                 = var.vm_cpu_num
  RAM                  = var.vm_mem_size
  cluster              = var.vcenter_cluster
  convert_to_template  = "true"
  guest_os_type        = "ubuntu64Guest"
  disk_controller_type = ["pvscsi"]
  
  
  insecure_connection  = "true"
  ip_wait_timeout      = var.vm_ip_timeout
  iso_urls             = [var.os_iso_url]
  iso_checksum         = var.os_iso_checksum
  network_adapters {
    network            = var.vcenter_network
    network_card       = var.vm_nic_type
  }
  cdrom_type = var.vm_cdrom_type
  firmware = var.vm_firmware
  notes                = "construído com Packer em ${local.timestamp}"
  password             = var.vcenter_password
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = false
  }

  // Configurações de boot e provisionamento do Guest
  
  boot_command = [
    "<esc><esc><esc>",
    "<enter><wait>",
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "boot<enter>"

  ]
  
  cd_content = {
  "meta-data" = file("${abspath(path.root)}/http/meta-data")
  "user-data" = local.user-data
  }
  
  cd_label = "cidata"

  boot_order = var.vm_boot_order
  boot_wait  = var.vm_boot_wait
  boot_keygroup_interval = "500ms"


  remove_cdrom = true
  shutdown_command = "echo '${var.ubuntu_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = var.vsphere_shutdown_timeout
  
  // Confifurações do comunicador do packer com  Credenciais
  communicator           = "ssh"
  ssh_username           = var.ubuntu_username
  ssh_password           = var.ssh_password
  ssh_handshake_attempts = var.ssh_handshake_attempts
  ssh_port               = var.communicator_port
  ssh_timeout            = var.communicator_timeout
  
  // Template Location
  datastore            = var.vcenter_datastore
  folder               = var.vcenter_folder
  host                 = var.vcenter_host
  
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = [
    "source.vsphere-iso.ubuntu-20-04-amd64-server"]
  provisioner "shell" {
    execute_command = "echo '${var.ubuntu_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.ubuntu_username}",
    ]
    scripts = var.shell_scripts
    expect_disconnect = true
  }
 }

