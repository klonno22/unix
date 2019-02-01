#!/bin/bash
#author Tom
#		ias101735

print_USAGE()
{
	echo "Usage:"
	echo "changetext.sh -h | changetext.sh --help"
	echo ""
	echo "prints this help and exits"
	echo ""
	echo "changetext.sh OP [CHAR1] [CHAR2] ..."
	echo ""
	echo "provides a simple text manipulation tool. A call consists of one to indefinite "
	echo "calls of the following OPs and their parameters. The text is read from stdin "
	echo "and the manipulated text is written to stdout."
	echo ""
	echo "OP is one of:"
	echo ""
	echo "  -r|--replace - replaces all characters CHAR1 in the given text with CHAR2. "
	echo "                 CHAR1 and CHAR2 have to be letters (A-Z,a-z) or digits (0-9)."
	echo ""
	echo "  -d|--delete - deletes all characters CHAR1 in the given text. CHAR1 has to "
	echo "                be a letter (A-Z,a-z) or a digit (0-9)."
	echo ""
	echo "  -u|--to-uppercase - replaces all lowercase characters in the given text with"
	echo "          their uppercase equivalent (i.e. a -> A, b -> B, ..)."
	echo ""
	echo "  -l|--to-lowercase - replaces all uppercase characters in the given text with"
	echo "          their lowercase equivalent (i.e. A -> a, B -> b, ..)."
}

existArg()
{
	#Testet ob $1 leer ""
	if [[ -z $1 ]]		
	then
		return 1
	else
		return 0
	fi
}

isNumOrLett()
{
	# Prüft ob Parameter Buchstabe / Zahl
	if [[ $1 =~ ^[a-zA-Z0-9]*$ ]]
	then
		return 0
	else
		error "Kein Buchstabe und oder keine Zahl"
	fi  
}

error() {
	#Umleitung auf Stderr und ausgabe der Fehler / Usage
	#return code 1
	>&2 echo "Error: $1"
	>&2 print_USAGE
	exit 1
}

#Für keine OP angabe
if (! existArg $1 )
then
	error "Es muss eine Operation angegeben werden"
fi

#Errorcode 0
#Usage ausgabe
if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]
then
	print_USAGE
	exit 0	
fi

#Testet ob echo in stdin geschrieben
if [[ ! -t 0 ]];		
then
	VALUE=$(cat -)		#Kopiert Text von stdin


	while [[ $# -gt 0 ]]      #Solange die Anzahl der Parameter ($#) größer 0
	do
		if [[ "$1" = "-r" ]] || [[ "$1" = "--replace" ]]
		then
			if ( ! existArg $2 ) || ( ! existArg $3 ) 
			then
				error "Es müssen zwei Parameter angegeben werden" 
			fi
			if (isNumOrLett $2) && (isNumOrLett $3)
			then
				#Ersetzt $2 durch $3
				VALUE=$(echo "$VALUE" | tr $2 $3) #Speichert VALUE modifiziert					
			fi
			shift 3		#Shiftet um 3 da 2 Parameter angegeben
		elif [[ "$1" = "-d" ]] || [[ "$1" = "--delete" ]]
		then
			if ( ! existArg $2 )
			then
				error "Es muss ein Parameter angegeben werden"
			else
				if (isNumOrLett $2) then
					VALUE=$(echo "$VALUE" | tr -d $2)	
				fi
				shift 2 #Shiftet um 3 da 1 Parameter angegeben
			fi
		elif [[ "$1" = "-u" ]] || [[ "$1" = "--to-uppercase" ]] || [[ "$1" = "-l" ]] || [[ "$1" = "--to-lowercase" ]]
		then	
			if [[ "$1" = "-u" ]] || [[ "$1" = "--to-uppercase" ]]
			then
				VALUE=$(echo "$VALUE" | tr '[a-z]' '[A-Z]')
			else
				VALUE=$(echo "$VALUE" | tr '[A-Z]' '[a-z]')
			fi
			shift 1
		else
			error "OP nicht gefunden"
		fi
		echo $VALUE
	done
else
	error "Kein Text zum bearbeiten"
fi
