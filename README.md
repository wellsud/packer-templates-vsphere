# Repositório de Templates Vmware para Servidores Windows e Ubuntu
Imagens construídas com [Hashicorp Packer](https://www.packer.io/) para automatização da criação/atualização dos Templates Básicos (Golden Images) de servidores Windows Server 2019 e Ubuntu 20.04 

## Cenário

- **Ambiente de Virtualização VMware Vsphere 6.5**: Com ESXi 6.5 como hipervisor nos hosts com aramzenamento via SAN. Vcenter 6.5

- **Recriação automática dos Templates Windows para atualização**: Os templates deveriam estar com as últimas atualizações do Windows Update para agilizar a resposta dos tickets.
  Foi definido que os templates deveriam atualizar pelo menos ao mês após o Patch Tuesday da Microsoft. 
  
- **IP estático**: Nosso ambiente funciona com ip estático e com restrição de saída para internet somente para máquinas que estejam no dominio e/ou autenticadas por usuário do dominio.

- **Experiência da Equipe de Infra com o uso de Git**: É o primeiro contato da maioria da equipe com git e ferramentas de Infraestrutura como Código então o processo para a customização e construção
  do template deveria ser a mais simples possível. Todos os arquivos e variáveis essenciais para nosso cenário foram documentadas aqui.

## Requisitos desse guia

- [Subsistema do Windows para Linux (WSL)](https://docs.microsoft.com/pt-br/windows/wsl/install). Ou sistema operacional Linux. Apesar de ser possível usar Windows com o Hashicorp Packer.
  a possibilidade de se chamar a tarefa agendada usando cron, python e packer foi mais simples de implementar usando Linux. A versão testada foi Ubuntu 18.04 ou superior.
- [Packer](https://www.packer.io/) versão 1.7 ou superior. Instruções para instalar o Packer [aqui](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli#installing-packer)
- É necessário já possuir uma iso do Windows Server 2019 carregado em algum armazzenamento acessivel ao vcenter.


## Como utilizar esse repositório

### Conhecendo a Estrutura de Arquivos

```
.
.
├── LICENSE
├── README.md
├── builds
│   ├── Linux
│   │   └── Ubuntu2004
│   │       ├── http
│   │       │   ├── meta-data
│   │       │   └── user-data.pkrtpl.hcl
│   │       ├── scripts
│   │       │   └── update _and_clean_server.sh
│   │       ├── ubuntu2004-server.auto.pkrvars.hcl
│   │       ├── ubuntu2004-server.pkr.hcl
│   │       └── variables.pkr.hcl
│   └── Windows
│       └── WindowsServer2019
│           ├── Core
│           │   └── Standard
│           │       ├── autounattend.pkrtpl.hcl
│           │       ├── scripts
│           │       │   ├── enable-winrm.ps1
│           │       │   ├── network.ps1
│           │       │   └── vmtools.cmd
│           │       ├── variables.pkr.hcl
│           │       ├── winsrv2019core.auto.pkrvars.hcl
│           │       ├── winsrv2019core.auto.pkrvars.hcl.template
│           │       └── winsrv2019core.pkr.hcl
│           └── GUI
│               └── Standard
│                   ├── autounattend.pkrtpl.hcl
│                   ├── scripts
│                   │   ├── enable-winrm.ps1
│                   │   ├── network.ps1
│                   │   └── vmtools.cmd
│                   ├── variables.pkr.hcl
│                   ├── winsrv2019std.auto.pkrvars.hcl
│                   ├── winsrv2019std.auto.pkrvars.hcl.template
│                   └── winsrv2019std.pkr.hcl
└── tasks
    ├── run_Win_Srv_2019_Core_task.py
    └── run_Win_Srv_2019_GUI_task.py
```

A pasta **builds** contém os scripts de criação separados por versão de sistema Operacional. Tomemos como exemplo a imagem do Windows Server 2019 Standar. Para criar um template vmware dessa versão é necessário acessar a pasta *builds\Windows\WindowsServer2019\Core\Standard*.
Dentro da pasta da Imagem os seguintes arquivos são encontrados:

### Para as imagens Windows

**autounattend.pkrtpl.hcl**: Template para o arquivo de respostas automaticas da instalação (Somente Windows).<br><br>
**scripts**: diretório onde ficaram os scripts de configuração e personalização pós instalação. Qualquer futura personalização via
script deve ser feita adicionando ou editando scripts aqui. Devido as nossas restrições e necessidades os scripts de configuração do ip estático
são mandatórios <br><br>
**variables.pkr.hcl**: Arquivo que define quais são as variáveis personalizaveis do template da Imagem. Não alterar a meno que novas
variáveis precisem ser criadas. Há uma gama muito maior de personalizações, porém as definidas atendem as necessidades do nosso dia-a-dia<br><br>
**winsrv2019core.auto.pkrvars.hcl.template**: Modelo para o arquivo que passará as variáveis que iremos alimentar. Para a execução
da automação é recomendado fazer uma cópia dele renomeando para winsrv2019core.auto.pkrvars.hcl. Depois de renomeá-lo é só preencher
os valores das variáveis com os valores correspondentes desejados. **Obs.:** *Esse arquivo está incluido no gitignore para evitar o commit de dados
sensíveis*<br><br>
**winsrv2019core.pkr.hcl**: Arquivo responsável pela criação do Template Vmware.<br><br>

### Para as Imagem Linux
A partir da versão 20.04 do Ubuntu Server o sistema de instalação padrão é o [Subiquity](https://ubuntu.com/server/docs/install/autoinstall-reference) que,
por sua vez, usa [curtin](https://curtin.readthedocs.io/en/latest/topics/overview.html) e [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) para provisionar uma imagem e fazer
a instalação automática. O cloud-init necessita de pelo menos dois arquivos:

**user-data.pkrtpl.hcl**: Similar ao autounattend do Windows é um arquivo que contem as informações de customização de atualização. Esse arquivo
contém as váriaveis básicas necessárias ao ambiente da empresa. Referência [aqui](https://ubuntu.com/server/docs/install/autoinstall-reference).

**meta-data**: Arquivo que contém meta dados do distribuidor da imagem da nuvem que será instalado. No nosso caso ficará em branco.

### Criação da Imagem - Passos

1 - Dentro de ua instalação linux do WSL, clonar o repositório git em sua máquina com o comando <br>
``` git clone git@github.com:iptsp/imagens_servidores.git ``` <br>
<br>
2 - Acessar a pasta do template que deseja criar. <br>
<br>
3 - Executar o comando abaixo que instala as dependências que o packer precisa para criar o template. Apenas a primeira vez <br>
``` packer init . ``` <br>
4 -  Para executar manualmente, ainda dentro da pasta digite: <br>
``` packer build . ``` <br>

**Obs.:** *o ponto é necessário e informa que os arquivos para a construção estão na pasta atual* <br>

### Execução agendada

Também é possível agendar via cron (recomendado) para que se execute automaticamente as tarefas de atualização. O script
de execucção está programada para executar 1 vez por mês em um determinado dia da semana. Por padrão a segunda quinta-feira do
mês. Para personalizá-lo e agendá-lo faça o seguinte:

1 - Após o clone do repositório acesse a pasta tasks e edite o arquivo da versão que de Image que deseja atualizar.
**Exemplo**: Para a versão Windows_Server_Core_2019_Standard o arquivo é ```run_Win_Srv_2019_Core_task.py``` 
2 - Altere somente as duas linhas marcadas com comentário inserindo o dia da semana e a semana do mês e salve o arquivo.
3 - No linux digite:
``` crontab -e ```
4 - Para executar a tarefa agendada todos os dias às 15h30 insira a seguinte linha no arquivo:
``` 30 15 * * * python3 /home/wellsud/imagens_servidores/tasks/run_Win_Srv_2019_Core_task.py```
A sintaxe é *mm hh dia mes diasemana commando*

## desafios e abordagem escolhida

 - A versão 6.5 apresenta um problema durante a customização da interface de rede no Ubuntu 20.04 devido a uma falha na execução de serviço do systemd durante
o boot conforme descrito [aqui](https://kb.vmware.com/s/article/59687). Esse erro só é corrigido a partir da versão 6.7. E apesar do KB a solução não resolveu
nosso problema. Para contornar a situação foi necessário alterar a informação do arquivo issue mudando a versão de 20.04 para 18.04 conforme 
[esta sugestão](https://github.com/vmware/open-vm-tools/issues/421#issuecomment-619276881). A solução foi incluida no script de customização *"update_and_clean_server.sh"*
nas linhas 103 e 104.

- Outro problema observado é que após personalizar o ip de uma maquina virtual criada a partir do template a mesma subia com dois ip's na interface e dois arquivos criados dentro
  de /etc/netapplyls /etc/netplan. Enxergando o ip original do template como default e não o novo ip configurado. Para contornar este problema foi necessário
  remover o arquivo yaml da pasta do netplan ao fim da configuração. Quando a máquina virtual é criada, um novo arquivo com a configuração customizada é criaod para 
  o netplan.
  
- Para facilitar o agendamento para um dia especifico da semana dentro do mês foi criado um script em python que é chamado pela tarefa agendada.

- Nas maquinas Windows em nosso ambiente foi necessário fixar um IP interno para os templates para que a exceção fosse aberta no Proxy e no Firewall para contornar
a restrição de saida para internet. Para a atualização após instalação fo usado o provisoner [windows-update](https://github.com/rgl/packer-plugin-windows-update) do packer

## Observações Importantes

Atenção para não subir arquivos com informações sensíveis (senhas e dados de usuário) para o repositório. Quaisquer arquivos do tipo
devem ser incluídos no .gitignore.

Caso use o script de agentamento no cron via wsl o serviço deve ser iniciado manualmente, pois não é iniciado por padrão no wsl.


