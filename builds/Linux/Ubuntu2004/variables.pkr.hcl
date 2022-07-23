# ----------------------------------------------------------------------------
# Name:         variables.pkr.hcl
# Description:  Definição de Variaveis para o Ubuntu Server 20.04
# Author:       Wellington Oliveira (@mpoore)
# URL:          https://github.com/v12n-io/packer
# Date:         26/05/2022
# ----------------------------------------------------------------------------

# -------------------------------------------------------------------------- #
#                         Deifinição de Variáveis                            #
# -------------------------------------------------------------------------- #


# Dados Sensíveis
variable "vcenter_username" {
    type        = string
    description = "Usuario para acesso ao vCenter"
    sensitive   = true
}

variable "vcenter_password" {
    type        = string
    description = "Senha para conectar ao vCenter"
    sensitive   = true
}

variable "ubuntu_username" {
    type        = string
    description = "Nome do usuario Usuario Inicial do Ubuntu"
    sensitive   = true
    
}

variable "ubuntu_password" {
    type        = string
    description = "Senha do usuario Ubuntu Padrão. Deve estar em formato criptografado"
    sensitive   = true
    
}

variable "ssh_password" {
    type        = string
    description = "Senha SSH para conexão remota"
    sensitive   = true
}

variable "pub_key" {
    type        = string
    description = "Chave publica para acesso SSH pelo packer. Deve ser gerada no computador de onde o Packer será executado"
    sensitive   = true
}

# Localização do Template

variable "vm_name" {
    type        = string
    description = "Nome do template"
    default     = "Ubuntu20.04-server"
}


variable "vcenter_server" {
    type        = string
    description = "FQDN do Vcenter"
}

variable "vcenter_cluster" {
    type        = string
    description = "Cluster onde a VM que se tornará template será criada"
}

variable "vcenter_host" {
    type        = string
    description = "Host (blade) onde a VM que se tornará template será criada"
}

variable "vcenter_datacenter" {
    type        = string
    description = "DataCenter onde a VM será criada"
 
}

variable "vcenter_folder" {
    type        = string
    description = "Pasta onde será criada a VM e se tornará template"

}
variable "vcenter_datastore" {
    type        = string
    description = "A LUN que será usada para o template"
}
variable "vcenter_network" {
    type        = string
    description = "VLAN onde a VM será criada"
}

variable "os_iso_path" {
    type        = string
    description = "caminho no Data Store onde se localiza a imagem ISO"
    default = ""
}

variable "os_iso_url" {
    type        = string
    description = "URL para a imagem ISO"
}

variable "os_iso_checksum" {
    type        = string
    description = "Checksum da imagem ISO"
}


# Configuração de Hardware Virtual
variable "vm_cpu_num" {
    type        = number
    description = "Quantidade de CPUs do Template"
    default     = 4
}

variable "vm_mem_size" {
    type        = number
    description = "The size of memory in MB for the VM"
}

variable "vm_nic_type" {
    type        = string
    description = "Tipo de driver de rede (ex 'e1000e' or 'vmxnet3')"
    default     = "vmxnet3"
}

variable "vm_disk_size" {
    type        = number
    description = "Tamanho do disco inicial em MB"
    default     = 40960
}

variable "vm_ip_address" {
    type        = string
    description = "Endereço IP da VM no formato CIDR" // Exemplo 10.18.25.250/16"
    
}

variable "primary_dns" {
    description = "Endereço IP do DNS primário"
    type        = string
    
}

variable "secondary_dns" {
    description = "Endereço IP do DNS secundário"
    type        = string
    
}

variable "vm_gateway" {
    type        = string
    description = "Endereço IP do Gateway"
    
}

variable "vm_firmware" {
    type        = string
    description = "Tipo de firmware (BIOS ou UEFI)"
    default     = "bios"
}

variable "vm_cdrom_type" {
    type        = string
    description = "Tipo de CDROM"
    default     = "sata"
}

// Configurações de Boot

variable "http_directory" {
  type    = string
  description = "Diretório dos arquivos de configuração(user-data, meta-data)."
  default = "http"
}

variable "vm_boot_order" {
  type        = string
  description = "Ordem de boot dos dispositivos."
  default     = "disk,cdrom"
}

variable "vm_boot_wait" {
  type        = string
  description = "Tempo de espera para o boot da VM."
  default = "30s"
}

variable "vsphere_shutdown_timeout" {
  type        = string
  description = "Tempo de espera para o Servidor desligar."
}

variable "shell_scripts" {
  type = list(string)
  description = "Scripts que serão executados no boot da VM."
  
}

variable "vm_ip_timeout" {
    type        = string
    description = "configure o tempo que o packer aguardará a configuração de IP da VM (e.g. '1h5m2s' or '2s')"
    default     = "1h"
}

# Variáveis do Arquivo User-data

variable "vm_guest_os_language" {
    type        = string
    description = "Idioma do sistema operacional"
    default     = "en_US.UTF-8"
} 

variable "vm_guest_os_timezone" {
    type        = string
    description = "Fuso horário do sistema operacional"
    default     = "America/Sao_Paulo"
}

variable  "vm_guest_os_keyboard" {
    type        = string
    description = "Teclado do sistema operacional"
    default     = "br"
}


//Variáveis de Comunicação com a VM

variable "ssh_handshake_attempts" {
  type        = string
  description = "Número de tentativas de handshake SSH"
}

variable "communicator_port" {
  type        = string
  description = "Porta de comunicação SSH"
}

variable "communicator_timeout" {
  type        = string
  description = "Tempo de espera para a conexão SSH"
}

# -------------------------------------------------------------------------- # 