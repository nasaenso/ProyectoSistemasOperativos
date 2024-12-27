# colores del texto
GREY="\e[90m"
GREEN="\e[32m"
RED="\e[31m"
BGREEN="32"
BRED="31"
BOLDRED="\e[1;${BRED}m"
BOLDGREEN="\e[1;${BGREEN}m"
ENDCOLOR="\e[0m"

usuario=""
vidas=3

# crear la barra de carga
function barraCarga {
	local progreso=$1
	local longitud_total=50
  	local relleno=$(($progreso * $longitud_total / 100))
	local vacio=$(($longitud_total - $relleno))

	printf "\r["
  	printf "\e[42m"  # Fondo verde
  	for ((i=0; i<relleno; i++)); do
    		printf " "
  	done
  	printf "\e[0m"  # Restablecer color

  	for ((i=0; i<vacio; i++)); do
    		printf " "
  	done
  	printf "] %d%%" "$progreso"
}

# crear y eliminar archivos 
function crearArchivosRandom {
	rm -rf .archivos
	mkdir .archivos
	cd .archivos

	for i in {1..150}; do
		nomAleatorio=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
		touch "$nomAleatorio"
	done


	# Reemplazar el nombre de usuario real con uno inventado
	local usuario_falso="bill"local grupo_falso="$usuario"
	ls -l | awk -v usuario="$usuario_falso" -v grupo="$grupo_falso" '{$3=usuario; $4=grupo; print}' | while IFS= read -r line; do
		echo "$line"
		sleep 0.01
	done

	cd ..
	clear
}

# función para que el texto vaya caracter por caracter
function escribir_texto {
	local texto="$1"
	local velocidad="$2"

	for (( i=0; i<${#texto}; i++ )); do
  		echo -n "${texto:$i:1}"
  		sleep "$velocidad"
  	done
  	echo
}


function inicio {

escribir_texto "Iniciando protocolo de seguridad. Por favor, mantente atento..." 0.05
sleep 2

for progreso in {0..100}; do
		barraCarga $progreso
	  	sleep 0.01
	done

sleep 2

echo
escribir_texto "Para acceder, necesitamos verificar tu identidad." 0.05
escribir_texto "Introduce los siguientes datos:" 0.05
escribir_texto "Usuario: " 0.05
read -p "" usuario

escribir_texto "Contraseña: " 0.05
read -p "" contrasena

escribir_texto "Procesando credenciales..." 0.05
escribir_texto "Espere un momento..." 0.5
sleep 2

echo -e "${BOLDGREEN}----------------------------------${ENDCOLOR}"
echo -e "${BOLDGREEN}¡Verificación de seguridad completada!${ENDCOLOR}"
echo -e "${BOLDGREEN}----------------------------------${ENDCOLOR}"
echo -e "${BOLDGREEN}Acceso concedido. Bien hecho, $usuario.${ENDCOLOR}"
echo ""

escribir_texto "Gracias por tu paciencia." 0.05
sleep 2
clear
}


function borrarFinal {
	if [ -d ".PCprueba/system32" ]; then
		echo -e "${BOLDRED} ¿Estás seguro de haber eliminado el archivo? Parece que aún sigue ahí. Inténtalo de nuevo. ${ENDCOLOR}"
		borrarAccion
		
	else 
		escribir_texto "¡Excelente trabajo! Has completado el tutorial." 0.05
		escribir_texto "Ahora comienza la verdadera misión. Prepárate para enfrentar retos mayores." 0.05
		pkill terminator
		level1
	fi
	
}

function borrarAccion {
	escribir_texto "¿Lograste borrar el archivo? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then
		clear
		borrarFinal
	else 
		escribir_texto "No te preocupes, intenta nuevamente. Asegúrate de haber escrito el comando correctamente. " 0.05 
		borrarAccion
	fi
}
	
function comando {
	echo -e "${GREY} comando system32 ${ENDCOLOR}"
	read -p "" comando
	if [ "$comando" == "rm -r system32" ]; then 
		clear
		echo -e "${GREY} rm -r system32 ${ENDCOLOR}"
		escribir_texto "¡Perfecto! Ese es el comando correcto. Ahora escríbelo en tu terminal y luego utiliza 'ls' para ver si lo eliminaste." 0.05
		cd .PCprueba 
		[ -d system32 ] && touch archiv_eliminado
		cd ..
		sleep 3
		borrarAccion
	else 
		escribir_texto "Comando incorrecto. Revisa el comando e inténtalo de nuevo." 0.05
		comando
	fi
}

function borrarSystem {
	escribir_texto "¿Encontraste un archivo sospechoso? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then
		clear
		escribir_texto "Ese archivo contiene malware y nos impedirá avanzar. No te preocupes, te enseñaré cómo eliminarlo." 0.05
		sleep 1
		escribir_texto "¿Recuerdas la imagen de comandos que te envié al inicio? Vuelve a revisarla, podría darte una pista sobre cómo proceder." 0.05
		sleep 5
		escribir_texto "¿Crees tener el comando correcto? Escríbelo a continuación seguido de 'system32'." 0.05
		comando
	else 
		escribir_texto "No te preocupes, intenta de nuevo y asegúrate de buscar correctamente." 0.05
		borrarSystem
	fi

} 

# función para cuando esté en el tutorial, se verifique si la contraseña obtenida está bien. si sí que pueda acceder a está
function contraLogrado {
	escribir_texto "Ingresa la contraseña para verificar si es correcta." 0.05
	read -p "" contra

	if [ "$contra" == "contrapruebaPC" ]; then
		echo -e "${BOLDGREEN} Contraseña válida. Tienes acceso a la computadora. ${ENDCOLOR}"
		escribir_texto "En tu terminal, escribe 'cd .PCprueba && ls' para explorar el sistema." 0.05
		sleep 2
		borrarSystem
	else 
		echo -e "${BOLDRED}Esa contraseña no parece correcta. Inténtalo nuevamente. ${ENDCOLOR}"
		contraLogrado
		sleep 3
	fi
}

function contraEncontrada {
	escribir_texto "¿Has obtenido la contraseña? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then
		clear
		escribir_texto "Perfecto. Ya que tienes la contraseña, puedes acceder al sistema." 0.05
		sleep 1
		contraLogrado
	else 
		clear
		escribir_texto "Asegúrate de haber ejecutado correctamente 'cat .contraseñaPrueba.txt' en la terminal que te proporcioné. Inténtalo de nuevo si es necesario." 0.05
		contraEncontrada
		sleep 5
	fi
}

function inicioTutorial {
	crearArchivosRandom
	cd ..
	rm -rf .archivos
	
	for progreso in {0..100}; do
		barraCarga $progreso
	  	sleep 0.01
	done

	echo -e " ${BOLDGREEN}Carga completa${ENDCOLOR}"
	sleep 2
	clear

	
	# inicia el texto
	echo -e " ${BOLDGREEN}Bienvenido, soy Bill${ENDCOLOR}"
	escribir_texto "Este mensaje no es solo información... es una llamada de ayuda." 0.05
	escribir_texto "Desde tu terminal, tienes acceso a una red de datos que podría cambiarlo todo." 0.05
	
}

# Tutorial
function tutorial {
	clear
	inicioTutorial
	sleep 1
	clear 
	
	echo -e "${BOLDGREEN}COMENCEMOS ${ENDCOLOR}"
	escribir_texto "Como estás dando tus primeros pasos en el hacking, vamos a revisar algunos comandos esenciales. Te serviran para ayudarme." 0.05
	escribir_texto "Cuando termines de ver la imagen con los comandos, ciérrala para continuar." 0.05
	escribir_texto "La imagen está guardada en tu escritorio, así que podrás consultarla cuando la necesites." 0.05
	sleep 3
	clear
	
	cd Escritorio
	mv .imgJuego.png imgJuego.png 
	echo -e "${GREY} Imagen de comandos guardada en el escritorio. (Recuerda escribirlos en minúscula) ${ENDCOLOR}" 
	eog imgJuego.png

	# Creo la PC del tutorial
	mkdir -p .PCprueba .PCprueba/system32
	echo "contrapruebaPC" > .contraseñaPrueba.txt 
	
	escribir_texto "He creado una PC de prueba para que puedas experimentar sin riesgos." 0.05
	escribir_texto "Se abrirá una nueva terminal (NO LA CIERRES). Escribe el siguiente comando en ella para ver la contraseña de prueba:" 0.05
    	escribir_texto "'cat .contraseñaPrueba.txt'" 0.05
	
	# le abro su terminal al jugador con terminator
	terminator &
	sleep 5
	contraEncontrada
}

############################
#fin nivel 1

function cuidad {
touch CUIDADO.txt
echo "Si estás leyendo esto, probablemente estás en medio de una misión que Bill te ha pedido realizar. Pero hay algo que debes saber: Bill no es quien crees. Se presenta como un aliado, como alguien que quiere usar sus habilidades para ayudar o combatir algo oscuro. Sin embargo, es todo lo contrario.

Bill es un experto en manipulación, y ya ha usado a otros antes de ti para hacer trabajos peligrosos y cubrir sus huellas. A ti, como a ellos, te ha convencido de que esta misión es por una buena causa, pero en realidad estás siendo usado.

Si sigues adelante, podrías verte atrapado en algo que él mismo jamás se atrevería a hacer. Piénsalo bien, y aléjate antes de que sea demasiado tarde. Este archivo es tu advertencia… tómalo en serio.
Esto te servirá mucho: Base64
—Dipper" > CUIDADO.txt
}

function finivel1 {
clear
sleep 3
escribir_texto "Gracias por tu ayuda..." 0.05
escribir_texto "La primera tarea está completa, puedes tomarte un breve descanso." 0.05
escribir_texto "Pero no te relajes demasiado, pronto sabrás de mí otra vez." 0.05
sleep 3
pkill terminator
}


function verificarEliminadoFinal {

	if [ -f ".RED/.PCpeligrosa/archivosSecretos/RASTREO.txt" ]; then
		echo -e "${BOLDRED} ¿Estás seguro de que lo eliminaste? Parece que aún sigue ahí. Inténtalo otra vez. ${ENDCOLOR}"
		sleep 1
		clear
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		VerificarEliminadoRastreo
		
	else 
		clear
		for progreso in {0..100}; do
			barraCarga $progreso
	  		sleep 0.01
		done
		cd .RED/.PCpeligrosa/archivosSecretos
		touch BillwasHere.txt
		echo "Enviando virus..." > BillwasHere.txt
		cd ..
		cd ..
		cd ..
		sleep 3
		clear
		escribir_texto "¡Bien! Ahora ejecuta 'ls' o 'ls R*' y fíjate si eliminaste el archivo." 0.05
		sleep 3
		finivel1
		
	fi

}

function VerificarEliminadoRastreo {
	escribir_texto "¿Lo eliminaste? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then
		clear
		verificarEliminadoFinal
	else 
		escribir_texto "Inténtalo de nuevo, y asegúrate de haberlo escrito correctamente." 0.05 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		verificarEliminadoRastreo
	fi
}
function eliminarRastreo {
	clear
	echo -e "${GREY}'comando nombre del archivo'${ENDCOLOR}"
	escribir_texto "RÁPIDO, revisa la imágen de comandos y encuentra el correcto para eliminar archivos! ¡Vamos, no tenemos todo el día! Escribelo a continuacion: " 0.05
	read -p "" comando

	if [ "$comando" == "rm -r RASTREO.txt" ]; then
		escribir_texto "PERFECTO, ahora escríbelo en tu terminal y elimínalo de una vez." 0.05
		sleep 1
		VerificarEliminadoRastreo
	else 
		echo -e "${BOLDRED} ¿Estás seguro de que ese es el comando? ${ENDCOLOR}"
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		eliminarRastreo
	fi
}

function accederRastreo {
	clear
	echo -e "${GREY}'imagen de comandos en el escritorio'${ENDCOLOR}"
	escribir_texto "Revisa la imagen que te dejé y escribe el comando aquí para leer al archivo: " 0.05
	echo -e "${GREY}'comando nombre del archivo'${ENDCOLOR}"
	read -p "" comando
	if [ "$comando" == "cat RASTREO.txt" ]; then 
		escribir_texto "Bien. Ahora ejecútalo en tu terminal." 0.05
		sleep 3
		clear
		sleep 1
		escribir_texto "¡Oh no! Tienen tus datos. Elimínalo antes de que sea tarde " 0.05
		eliminarRastreo

	else 
		escribir_texto "Incorrecto otra vez. Quizá escribiste mal el comando o el nombre del archivo. Asegúrate esta vez." 0.05
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		accederRastreo	
	fi
	
}

function encontrarRaro {
	clear
	echo -e "${GREY}'cd archivosSecretos' y luego 'ls'${ENDCOLOR}"
	escribir_texto "¿Lograste encontrar el archivo con un nombre sospechoso? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then 
		clear
		sleep 2
		escribir_texto "¡Por fin! Al acceder a esta computadora dejaste un rastro." 0.05
		escribir_texto "Para ver su contenido, usa el comando correcto seguido del nombre del archivo RASTREO.txt." 0.05
		sleep 2
		accederRastreo

	else 
		escribir_texto "Intenta de nuevo. Si no lo encontraste, escribe 'ls R*' en tu terminal." 0.05
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		clear
		encontrarRaro
		
			
	fi
}

function ingresarArchivosSecretos {
	echo -e "${GREY} comando archivosSecretos ${ENDCOLOR}"
	read -p "" comando
	if [ "$comando" == "cd archivosSecretos" ]; then 
		clear
		escribir_texto "Por fin... Escribe 'cd archivosSecretos' y luego 'ls' en tu terminal y dime si encuentras algo útil." 0.05	
		sleep 1
		escribir_texto "Como verás, hay bastantes archivos ahí." 0.05
		escribir_texto "Tu tarea es encontrar uno en específico. Búscalo ATENTAMENTE" 0.05
		sleep 2
		encontrarRaro
	else 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas. Ya deberías saber qué hacer. Inténtalo de nuevo." 0.05 		escribir_texto "Escribelo a continuacion el comando para acceder a archivosSecretos" 0.05
		clear
		ingresarArchivosSecretos	
	fi
	
}
function archivosRaris {
	clear
	echo -e "${GREY} 'ls' ${ENDCOLOR}"
	escribir_texto "¿Has encontrado algún archivo con un nombre extraño? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then 
		clear
		escribir_texto "Excelente, ingresa a ese archivo usando el comando correcto. Si has estado atento, ya deberías saber cuál es." 0.05
		escribir_texto "Escribelo a continuacion: " 0.05
		ingresarArchivosSecretos
	else 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas. No es momento de dudar. Si no encuentras nada, revisa de nuevo." 0.05
		escribir_texto "intentalo de nuevo" 0.05
		clear
		archivosRaris
			
	fi
}

function entrarPCNivel1 {
	echo -e "${GREY} comando .PCpeligrosa ${ENDCOLOR}"
	escribir_texto "Escribe el comando correcto para acceder a la computadora: " 0.05
	read -p "" comando
	if [ "$comando" == "cd .PCpeligrosa" ]; then 
		escribir_texto "Bien. Era lo que esperaba. Ahora ejecútalo en tu terminal y usa 'ls' para ver qué encuentras." 0.05
		sleep 3
		archivosRaris
	else 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas. Por favor, concéntrate." 0.05
		escribir_texto "Inténtalo de nuevo, y presta más atención." 0.05
		clear
		entrarPCNivel1
	fi
}

function pcEncotrada {
	clear
	echo -e "${GREY} 'cd .RED y luego ls -la' ${ENDCOLOR}"
	escribir_texto "¿Alguna de las PCs te parece sospechosa? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then 
		clear
		entrarPCNivel1
	else 
		escribir_texto "Intenta otra vez, y fíjate bien en los detalles. (Puede que hayas escrito mal el comando o el nombre de la PC)" 0.05
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas. Trata de no desperdiciarlas." 0.05
		clear
		pcEncotrada	
	fi
}

function revisarConeccion {
	echo -e "${GREEN} comando .RED ${ENDCOLOR}"
	escribir_texto "Escribe el comando correcto seguido de '.RED': " 0.05
	read -p "" comando
	if [ "$comando" == "cd .RED" ]; then 
		clear
		echo -e "${GREY} cd .RED ${ENDCOLOR}"
		escribir_texto "Correcto. Ahora ejecútalo en tu terminal y luego usa 'ls -la' para ver si encuentras algo interesante." 0.05
		sleep 3
		pcEncotrada
	else 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas." 0.05
		escribir_texto "intenta de nuevo" 0.05
		clear
		revisarConeccion
	fi
}

function redNivel1 {
	
	escribir_texto "¿Encontraste el comando para conectarte? (si/no)" 0.05
	read -p "" res
	if [ "$res" == "si" ]; then 
		clear
		revisarConeccion
		
	else 
		let vidas=($vidas-1)
		contador
		escribir_texto "Te quedan $vidas vidas. No puedo esperarte eternamente... inténtalo de nuevo." 0.05
		clear
		redNivel1	
	fi
	
}

function level1 {
	# Borre la pc y contraseña del tutorial
	verificarArchivos
	clear
	
	# crea pc y contraseña del nivel 1
	mkdir -p .RED .RED/.PCpeligrosa .RED/.PC2 .RED/.PC3
	chmod 000 .RED/.PC2
	chmod 000 .RED/.PC3
	cd .RED
	cd .PCpeligrosa
	crearArchivosRandom
	cd .archivos
	touch RASTREO.txt
	echo "$usuario a ingresado a tu computadora. ALERTA" > RASTREO.txt
	cuidad
	cd ..
	mv .archivos archivosSecretos
	cd ..
	cd ..
	
	#escribir algo mejor
	echo -e "${RED}RECUERDA: ESTÁS MANIPULANDO UNA COMPUTADORA REAL.${ENDCOLOR}"
	escribir_texto "No es momento para errores... actúa con precisión." 0.05
	escribir_texto "He dejado en tu escritorio los recursos para tu primera tarea." 0.05
	mv .imgJuego.png imgJuego.png
	sleep 2
	clear
	escribir_texto "No puedo permitirme que cometas errores en este caso. Sé cuidadoso, y sigue las instrucciones al pie de la letra." 0.05
    	escribir_texto "Escucha: tu misión ahora es localizar la computadora de un individuo muy peligroso. Esto no es un juego." 0.05

	escribir_texto "Pero primero, conéctate a la RED. Ya debería estar claro, ¿verdad?" 0.05
	sleep 1
	escribir_texto "Te abriré una nueva terminal para que puedas proceder." 0.05
	terminator &
	sleep 2
	
	clear
	echo -e "${GREY} Imagen de comandos disponible en el escritorio.${ENDCOLOR}" 
	sleep 1
	redNivel1
	}

# la pantalla de inicio
function verificarArchivos {	
	
	clear
	
	[ -d .PCprueba ] && rm -rf .PCprueba  && rm .contraseñaPrueba.txt
	[ -f imgJuego.png ] && mv imgJuego.png .imgJuego.png
	[ -d archivos ] && mv archivos .archivos
	[ -d .archivosSecretos ] && rm -rf .archivosSecretos
  	[ -d .RED ] && rm -rf .RED
  	[ -d .PC ] && rm -rf .PC 
  		
}

# el orden del juego 
function juego {
	inicio
	echo -e "${GREY}No es recomendable saltearse el tutorial si es su primera vez jugando.${ENDCOLOR}"
   	echo -e "${BOLDGREEN}==============================${ENDCOLOR}"
    	echo -e "${BOLDGREEN}       MENÚ PRINCIPAL         ${ENDCOLOR}"
    	echo -e "${BOLDGREEN}==============================${ENDCOLOR}"
    	echo
    	echo -e "${BOLDGREEN}0) Tutorial${ENDCOLOR}"
    	echo -e "${BOLDGREEN}1) Nivel 1${ENDCOLOR}"
    	echo -e "${BOLDRED}2) Cerrar${ENDCOLOR}"
    	echo
    	echo -e "${BOLDGREEN}==============================${ENDCOLOR}"
    	escribir_texto "Selecciona una opción: " 0.05
    
	read -p "" op
	case $op in
		0) tutorial
		;;
		1) level1
		;;
		2) echo -e "${BOLDRED}Cerrando juego..${ENDCOLOR}"
		escribir_texto "..." 0.5
		exit
		;;
	esac
}

function contador {
if [ $vidas -le 0 ]; then
    perdiste
fi
}
function perdiste {
	verificarArchivos
    clear
    echo -e "${BOLDRED}==============================${ENDCOLOR}"
    echo -e "${BOLDRED}      ¡HAS SIDO HACKEADO!      ${ENDCOLOR}"
    echo -e "${BOLDRED}==============================${ENDCOLOR}"
    sleep 2
    escribir_texto "Vaya, $usuario... Pensaste que esto era solo un juego." 0.05
    sleep 1
    escribir_texto "Gracias por tu cooperación. Ahora tengo toda tu información." 0.05
    sleep 1
    escribir_texto "Tu nombre de usuario: $usuario" 0.05
    sleep 1
    escribir_texto "Y tu contraseña: $contrasena" 0.05
    sleep 1
    escribir_texto "Con esto, puedo hacer mucho más de lo que imaginas." 0.05
    sleep 1
    escribir_texto "Te lo advertí: siempre hay que ser cuidadoso con quién confías tus datos." 0.05
    echo -e "${BOLDRED}==============================${ENDCOLOR}"
    escribir_texto "Adiós, $usuario... Quizá no tengas otra oportunidad de aprender esta lección." 0.05
    sleep 3
    eog .lol.png
    exit

}
gsettings set org.gnome.desktop.background picture-uri ""
gsettings set org.gnome.desktop.background primary-color "#00001B"

verificarArchivos
juego

