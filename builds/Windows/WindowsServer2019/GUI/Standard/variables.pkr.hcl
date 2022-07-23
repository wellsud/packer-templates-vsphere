# ----------------------------------------------------------------------------
# Name:         variables.pkr.hcl
# Description:  Definição de Variaveis para o Windows 2019 Core
# Author:       Wellington Oliveira (@mpoore)
# URL:          https://github.com/v12n-io/packer
# Date:         03/05/2022
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

variable "admin_username" {
    type        = string
    description = "Nome do usuario administrador Padrão"
    sensitive   = true
    default     = "Administrator"
}

variable "admin_password" {
    type        = string
    description = "Senha do usuario administrador Padrão"
    sensitive   = true
    
}

variable "windows_product_key" {
    type        = string
    description = "Chave de produto para instalação do Windows"
    sensitive   = true
}

# Localização do Template

variable "vm_name" {
    type        = string
    description = "Nome do template"
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
    description = "Host (lâmina) onde a VM que se tornará template será criada"
}

variable "vcenter_datacenter" {
    type        = string
    description = "VLAN onde a VM será criada"
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


# Configurações de espera
variable "vm_ip_timeout" {
    type        = string
    description = "configure o tempo que o packer aguardará a configuração de IP da VM (e.g. '1h5m2s' or '2s')"
    default     = "1h"
}


# Personalizacao autounattended

variable "organization" {
    type        = string
    description = "Nome abreviado da empresa que irá na Instalação do Windows"
}

variable "fullname" {
    type        = string
    description = "Nome completo da empresa ou usuario que irá na Instalação do Windows"
}

# variáveis do script

variable "ip_address" {
    type        = string
    description = "ip inicial do template"
}

variable "prefixLength" {
    type        = number
    description = "Tamanho do prefixo de rede. Referente a máscara de rede"
}

variable "primary_dns" {
    type        = string
    description = "dns primário"
}

variable "secondary_dns" {
    type        = string
    description = "dns secundário"
}

variable "gateway" {
    type        = string
    description = "gateway para a rede do template" 
}
variable "proxy" {
    type        = string
    description = "endereco do proxy no fomato protocolo://proxy_ip:porta"
}
# -------------------------------------------------------------------------- #
