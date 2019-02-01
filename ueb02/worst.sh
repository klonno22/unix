#!/bin/sh
#author Tom & Marc
#		ias101735 & ...
#
#		grep -v -i -x "ERROR"		
#		grep Sucht -v inverse nach error in Textdatei -i egal ob Groß / Kleinschreibung und wird nur bei genauer Übereinstimmung ignoriert
#		sort -t ":" -k 3 -k 2 -n -r -u		
#		Sortiert nach einem bestimmten Zeichen -t ":" -k 3 ab dem 3 Feld bis Zeilenende. Danach wird das zweite Feld Sortiert. -n Sortiert es numerisch, -r reverse(Aufsteigende Sortierung)
#		und -u das jede Zeilte nur einmal geprüft wird.
#		tee "$1"
#		Erste zu übergebene Parameter auf der Kommandozeile
#		tail -n -1
#		tail gibt alles ab Zeile 1 aus
#		cut -d ":" -f 1
#		löscht alles bis zum ersten : inklusive des :
#

# ERGÄNZUNG tee liest alles auf Stdin ein und gibt es in Stdout und als FIle aus
grep -v -i -x "ERROR" | sort -t ":" -k 3 -k 2 -n -r -u | tee "$1" | tail -n -1 | cut -d ":" -f 1
 