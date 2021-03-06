#!/bin/bash
#
# re-tester.sh
# Novembro de 2009
# Luis Henrique <contato@luishenrique.org>
#
# Script para testar Expressoes Regulares
# Destaca os metacaracteres na ER
# 
# Obs: o script usa o egrep sem o -x, ou seja,
# retorna tambem se nao casar exatamente com o padrao 
#
# Referencia em ER: http://aurelio.net/er
#

# Cores  
cN=`echo -ne "\033[m"`      # normal
cI=`echo -ne "\033[7m"`     # inverso
cR=`echo -ne "\033[1;31m"`  # vermelho
cG=`echo -ne "\033[1;32m"`  # verde
cY=`echo -ne "\033[1;33m"`  # amarelo
cB=`echo -ne "\033[1;34m"`  # azul
cP=`echo -ne '\033[1;35m'`  # rosa

# Metacaracteres
repres="\[ ]" # falta o lista negada \[^
quantif="? '*' + { }"
ancora="[\b] \\^ \\\$"
outros="\\\ | ( )"

# Funcao principal que "highlighteia" a expressao regular

re_highlight(){

	# vermelho nos representantes
	for i in $repres; do
		ER=`echo $ER | sed -e "s/$i/$cR&$cN/g"`
	done

	# amarelo nos quantificadores
	for i in $quantif; do
		ER=`echo $ER | sed -e "s/$i/$cY&$cN/g"`
	done

	# rosa nos outros
	for i in $outros; do
		ER=`echo $ER | sed -e "s/$i/$cP&$cN/g"`
	done

	# verde nos tipo ancora
	for i in $ancora; do
		ER=`echo $ER | sed -e "s/$i/$cG&$cN/g"`
	done
	
}

# main

if [ $# == 2 ] # Verifica se tem somente 2 argumentos
then
	PATTERN=$1 # o padrao e' o primeiro argumento
	REGEX=$2 # a ER e' o segundo argumento
	
	ER=$REGEX # faz backup da ER original pra nao atrapalhar o egrep
	
	re_highlight;

	#clear	# limpa o console
	echo -e "$cI Testador de Expressao Regular $cN\n"

	echo -ne "Regex: $ER\n"
	echo -n "${cN}Padrao:" ; echo -e "$cB $PATTERN\n"
	echo -ne "${cN}Resultado: "

	# Verifica se casa e mostra o resultado
	if ( echo $PATTERN | egrep --color=always $REGEX )
	then
		echo "$cN"
	else
		echo -e "${cR}Nao casou.\n$cN"
	fi
	
else
	echo -e "Uso: $0 <padrao> <expressao-regular>\n"
fi
