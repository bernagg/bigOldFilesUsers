#!/bin/bash
# file: bigOldFilesUsers.sh
# versió: v0.9
# autor: Bernabé Gonzalez Garcia
# data: 19/02/2013
# descripció: Script administratiu que s'ha d'executar com a root. Busca arxius de 
# certa antiguitat i tamany per a tots els usuaris del PC depenent dels paràmetres que li 
# fiquin, i envia un mail per bash a l'usuari amb un avís. Aquests arxius s'esborraran a 
# partir de d'ara en 48 hores.


# Si no ens entren arguments, true. Funció per defecte.
if [ "$#" -eq 0 ]
then
	# Agafem la llista d'usuaris que tenen un profile al sistema, busquem el bash profile i home per 
	# a cada usuari per a retallar correctament als usuaris i no d'altres coses. Retallem la primera posició 
	# de la recerca (el nom d'usuari).
	USERS=$(cat /etc/passwd |grep bash |grep home | awk -F: '{print $1}')
	# Fem un bucle per a tota la llista d'usuaris.
	for linea in $USERS;
	do
		# Per cada iteració, ens en anem d'excursió al directori de $USERS (usuari).
		cd /home/$linea
		# Fem la recerca per defecte d'arxius que tenen 10mb i 3 mesos d'antiguitat.
		ARXIUSTEMPS=$(find -size +10000 -atime +90)
		# Mirem la longitud del contingut de $ARXIUSTEMPS (el contingut és text) i en cas
		# de ser superior a 0, true.
		if [ ${#ARXIUSTEMPS} -gt 0 ]
		then
			# Fiquem un missatge inicial per a l'estimat usuari que li adverteix de les 
			# nostres males intencions.
			TEXT=$(echo "Tens arxius que se'n esborraran d'aquí 48 hores. La llista és la següent: ")
			# Agafem el missatge anterior, juntament amb el contingut de $ARXIUSTEMPS 
			# (arxius per esborrar) i li enviem.
			$(echo $TEXT $'\n' $ARXIUSTEMPS | mail -s "Urgent" $linea) 
			# Enviem l'ordre de esborrar els arxius en 48 hores.
			echo "rm -f $ARXIUSTEMPS" | at now + 48 hours
		fi
	done
# Si l'usuari ens dona dos valors, els agafem. El procediment és identic a l'anterior però
# amb una petita modificació.	
elif [ "$#" -eq 2 ] 
then
	USERS=$(cat /etc/passwd |grep bash |grep home | awk -F: '{print $1}')
		for linea in $USERS;
		do
			cd /home/$linea
			# Tenim en compte els valors que es introdueix per la terminal $1 (tamany) $2 (temps).
			ARXIUSTEMPS=$(find -size $1 -atime $2)
			if [ ${#ARXIUSTEMPS} -gt 0 ]
			then
				TEXT=$(echo "Tens arxius que se'n esborraran d'aquí 48 hores.
				 La llista és la següent: ")
				$(echo $TEXT $'\n' $ARXIUSTEMPS | mail -s "Urgent" $linea)
				echo "rm -f $ARXIUSTEMPS" | at now + 48 hours
			fi
		done	
# Si l'usuari ens dona un paràmetre, true. Els procediment és similar al primer, 
# però amb una petita modificació.
elif [ "$#" -eq 1 ] 
then
	USERS=$(cat /etc/passwd |grep bash |grep home | awk -F: '{print $1}')
		for linea in $USERS;
		do
			cd /home/$linea
			# Tenim en compte el primer valor que es introdueix per la terminal $1(tamany).
			ARXIUSTEMPS=$(find -size $1 -atime +90)
			if [ ${#ARXIUSTEMPS} -gt 0 ]
			then
				TEXT=$(echo "Tens arxius que se'n esborraran d'aquí 48 hores.
				 La llista és la següent: ")
				$(echo $TEXT $'\n' $ARXIUSTEMPS | mail -s "Urgent" $linea) 
				echo "rm -f $ARXIUSTEMPS" | at now + 48 hours
			fi
		done			
# Si ens posa més de 2 paràmetres, true.
elif [ "$#" -gt 2 ]
then
	# Retornem una petita ajuda per a l'usuari.
	echo "Error!"
	echo "Si vols consultar arxius més grans que 10mb i 3 mesos d'antiguitat la 
	forma correcta és ./script.sh"
	echo "Si vols consultar arxius més grans que X i Y mesos d'antiguitat la forma 
	correcta és (on X es el pes, i Y l'antiguitat) ./script.sh \$X \$Y"
	exit 1
fi

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
