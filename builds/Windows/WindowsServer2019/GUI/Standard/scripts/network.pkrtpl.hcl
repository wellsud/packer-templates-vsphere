
#Configurando IP estatico
New-NetIPAddress -IPAddress ${ip_address} -DefaultGateway ${gateway}  -PrefixLength ${prefixLength} -InterfaceIndex (Get-NetAdapter).InterfaceIndex

#Configurando DNS
$index = (Get-NetAdapter).InterfaceIndex
$dns = (${primary_dns},${secondary_dns})
Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses $dns

#Desabilitando firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Habilitando RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

#Configurando proxy para maquina atualizar no Microsoft Update
netsh winhttp set proxy ${proxy}

#após configuração, reiniciar o Windows Update
Restart-service wuauserv
