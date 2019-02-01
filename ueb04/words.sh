#!/bin/bash
#author Tom
#		ias101735

#Gibt die Usage auf Sdtout aus
print_USAGE() {
	echo "Usage:"
	echo "words.sh -h | words.sh --help"
	echo "  print this help and exit"
	echo ""
	echo "words.sh [OPTS] WORD [OPTS]"
	echo "  where WORD is a word or a phrase that has a wiktionary entry"
	echo "    (it is not allowed to start with \"-\" but can contain spaces)"
	echo "  where OPTS is one or more of"
	echo "    -i, --idiom         extract and print the idioms"
	echo "    -s, --synonym       extract and print the synonyms"
	echo "    -y, --hyphenation   extract and print the hyphenation"
	echo "    -m, --meaning       extract and print the meanings"
}

#Formatiert den übergebenen Text und verarbeitet nach übergebenem Parameter
#$1 der übergebene Text
#$2 das zu suchende Object in dem Text
format_HTML() {
	VAL=$(echo "$1" | tr "\n" " " | sed 's/<p>/\n<p>/g' | grep id=\"$2\" | sed 's/<dd>/\n<dd>/g' | sed 's/<[^>]*>//g' | sed '/^$/d' | sed 's/ *$//g' | sed 's/^ *//g')
	echo "$VAL"
}

#Umleitung auf Stderr und ausgabe der Fehler / Usage
#return code 1
error()
{
	>&2 echo "Error: $1"
	>&2 print_USAGE
	exit 1
}

#Prüft ob ein Übergebener Parameter bereits gesetzt wurde
#$1 Gibt die Zahl welche Position des Arrays geprüft werden soll
#@return gibt 0 oder einen Fehler zurück
is_ok()
{
	if [[ ${IS_VALID[$1]} = 1 ]]
	then
		error "Es darf jeder Parameter nur einmal angegeben werden!"
	else
		return 0
	fi
}
#Errorcode 0
#Usage ausgabe
if ([[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]) && [[ $# = 1 ]]
then
	print_USAGE
	exit 0
fi

IS_VALID=(0 0 0 0 0)
WORD=""


#While Schleife zur Verarbeitung der Parameter
while [[ $# -gt 0 ]]
do
	if [[ $1 == -* ]]
	then
		if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]
		then
			error "-h / --help darf nicht mit anderen Parametern verknüpft werden!"
		elif ([[ "$1" = "-i" ]] || [[ "$1" = "--idioms" ]]) && is_ok 0
		then
			IS_VALID[0]=1
		elif ([[ "$1" = "-s" ]] || [[ "$1" = "--synonym" ]]) && is_ok 1
		then
			IS_VALID[1]=1
		elif ([[ "$1" = "-y" ]] || [[ "$1" = "--hyphenation" ]]) && is_ok 2
		then
			IS_VALID[2]=1
		elif ([[ "$1" = "-m" ]] || [[ "$1" = "--meaning" ]]) && is_ok 3
		then
			IS_VALID[3]=1
		else
			error "OP nicht gefunden"
		fi
	else
		if [[ ${IS_VALID[4]} = 1 ]]
		then
			error "Es darf nur ein Wort angegeben werden"
		fi
		WORD=$(echo $1 | tr " " "_")
		IS_VALID[4]=1
	fi
	shift 1
done

if [[ $WORD = "" ]]
then
	error "Kein Wort angegeben!"
fi

if [[ (${IS_VALID[0]} = 0) && (${IS_VALID[1]} = 0) && (${IS_VALID[2]} = 0) && (${IS_VALID[3]} = 0) ]]
then
	error "Kein Parameter angegeben"
fi


FILE=$(cat "cache/$WORD.html")

if [[ ${IS_VALID[0]} = 1 ]]
then
	format_HTML "$FILE" "Redewendungen"
fi
if [[ ${IS_VALID[1]} = 1 ]]
then
	format_HTML "$FILE" "Synonyme"
fi
if [[ ${IS_VALID[2]} = 1 ]]
then
	format_HTML "$FILE" "Worttrennung"
fi
if [[ ${IS_VALID[3]} = 1 ]]
then
	format_HTML "$FILE" "Bedeutungen"
fi
