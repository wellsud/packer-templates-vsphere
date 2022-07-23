import datetime as date
from distutils.log import error
from subprocess import Popen, PIPE, CalledProcessError



date_today = date.datetime.now()

weekdays = { "Segunda": 0, "Terca": 1, "Quarta": 2, "Quinta": 3, "Sexta": 4, "Sabado": 5, "Domingo": 6 }
week_of_month = {
    "Primeira": range(1,8),
    "Segunda": range(8,15),
    "Terceira": range(15, 22),
    "Quarta": range(22, 29),
    "Quinta": range(29, 32)
}

update_day = weekdays["Quinta"] # <---- Preencha aqui o dia da semana que deseja executar o script
update_week = week_of_month["Segunda"] # <---- Preencha aqui a semana do mês que deseja executar o script



if(date_today.weekday() == update_day): 
    if(date_today.day in update_week):

        message = "Hoje é  {today}. {weekMonth} {weekday}. \
            Hora de atualizar Templates Windows Server".format(today = date_today.strftime("%d/%m/%y"),
            weekMonth = update_week, weekday = update_day)
               
        
        print(message)    
        
        bashCommand = "packer build -force ."
        changeWorkingDirectory = "/home/wellsud/imagens_servidores/builds/Windows/WindowsServer2019/GUI/Standard/"
        
        with Popen(bashCommand.split(), stdout=PIPE, bufsize=1, universal_newlines=True, cwd=changeWorkingDirectory) as p:
           for line in p.stdout:
               print(line, end='')
        
        if p.returncode != 0:
            raise CalledProcessError(p.returncode, p.args)
        
        
        

     
    

