#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
  echo -e "\n\n${redColour}[+] Saliendo...${endColour}\n"
  tput cnorm
  exit 1  
}

#Ctrl + c
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ${endColour}${purpleColour}$0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour} ${grayColour}Cantidad total de dinero inicial${endColour}\n"
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Técnica que deseas emplear${endColour}${turquoiseColour} (martingala/inverseLabrouchere)${endColour}\n"
  echo -e "\t${blueColour}-h)${endColour} ${grayColour}Mostrar el panel de ayuda${endColour}\n"
  
  exit 1

}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual${endColour} ${greenColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Cuánto dinero quieres apostar? -> ${endColour}${greenColour}" && read initial_bet && echo -ne "${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente${endColour} ${purpleColour}(par/impar)${endColour}${grayColour}? -> " && read par_impar && echo -ne "${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad de${endColour} ${greenColour}$initial_bet${endColour} a ${purpleColour}$par_impar${endColour}"
  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas="[ "
  maximo_dinero=0
  tput civis #Ocultar el cursor

  while true; do
    random_number="$(($RANDOM % 37))"
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour} Acabas de apostar ${blueColour}$initial_bet${endColour} y tienes ${greenColour}$money€${endColour}"
#    echo -e "Ha salido el número $random_number"

    if [ ! "$money" -le 0 ]; then
     if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
#            echo -e "${redColour} [!] Ha salido el cero, ¡pierdes!${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes ${endColour}${greenColour}$money€${endColour}"

          else
#            echo -e "${greenColour}El número es par, ¡ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de ${endColour}${greenColour}$reward€${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes ${endColour}${greenColour}$money€${endColour}"
            initial_bet=$backup_bet
            jugadas_malas=""

            if [ "$money" -gt "$maximo_dinero" ]; then
              maximo_dinero="$money"
            fi
       
          fi
        else
#          echo -e "${redColour}El número es impar, ¡pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes ${endColour}${greenColour}$money€${endColour}"
          jugadas_malas+="$random_number "
        fi
      fi
    else
      echo -e "\n${redColour}[!] Te has quedado sin dinero, la banca siempre gana${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${yellowColour}$play_counter${endColour} jugadas"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}El máximo dinero que has logrado tener ha sido${endColour} ${greenColour}$maximo_dinero€${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}A continuación se van a representar las jugadas malas que han salido:${endColour}"
      echo -e "${blueColour}   $jugadas_malas${endColour}"
      tput cnorm; exit 0
    fi
    let play_counter+=1
  done
  
  tput cnorm
}


while getopts "m:t:h" arg; do
  case $arg in
  m) money=$OPTARG;;
  t) technique=$OPTARG;;
  h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala

  else
    echo -e "\n${redColour}[!] La técnica $technique no existe${endColour}"
    helpPanel
  fi
  
else
  helpPanel
fi
