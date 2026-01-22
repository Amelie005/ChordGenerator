#!/bin/bash
#soll mit Bash ausgeführt werden

#Grundakkorde in Array
ROOTS=("C" "D" "E" "F" "G" "A" "B")

#Typen nach Genre in Arrays
ROCK_TYPES=("maj" "min" "7")
POP_TYPES=("maj" "min" "maj7" "m7")
JAZZ_TYPES=("maj7" "m7" "7" "m7b5" "dim7")

echo "Willkommen!"
echo "------------------------------------------------------"

#Modus wählen
echo "Wähle Modus:"
echo "1) Einzelner Akkord"
echo "2) Akkordprogression"
read -p "> " MODE #speichert Benutzereingabe in "MODE"
MODE="${MODE//$'\r'/}"  #entfernt nicht sichtbares Windows Zeichen \r (Carriage return), also Windows Zeilenende

#prüft ob Eingabe gültig ist
if [[ "$MODE" != "1" && "$MODE" != "2" ]]; then
	echo "Ungültige Auswahl"
 	exit 1
fi

#Prüfen auf Environment-Variable: CHORD_STYLE_DEFAULT
# Wenn gesetzt (1=Rock, 2=Pop, 3=Jazz), wird sie direkt verwendet
if [[ -n "$CHORD_STYLE_DEFAULT" ]]; then
	STYLE="$CHORD_STYLE_DEFAULT"
	echo "Genre automatisch gewählt über CHORD_STYLE_DEFAULT=$STYLE"
else
	#Genre wählen
	echo "Wähle Songstil:"
	echo "1) Rock"
	echo "2) Pop"
	echo "3) Jazz"
	read -p "> " STYLE #liest Eingabe und speichert sie in STYLE
	STYLE="${STYLE//$'\r'/}"  #CR wieder entfernen 
fi

#Je nach Eingabe passendes Array an Akkordtypen in TYPES gesp.
#Name des Stils ebenfalls gesetzt (@: alle Elemente des Arrays)
case "$STYLE" in
	1) TYPES=("${ROCK_TYPES[@]}"); STYLE_NAME="Rock" ;;
    	2) TYPES=("${POP_TYPES[@]}"); STYLE_NAME="Pop" ;;
    	3) TYPES=("${JAZZ_TYPES[@]}"); STYLE_NAME="Jazz" ;;
    	*) echo "Ungültige Auswahl"; exit 1 ;;
esac

echo "------------------------------------------------------"

if [[ "$MODE" == "1" ]]; then
	# Einzelakkord
    	ROOT=${ROOTS[$RANDOM % ${#ROOTS[@]}]} #Random gibt Zufallszahl , ${#ROOTS[@]} begrenzt sie auf die Länge des Arrays
    	TYPE=${TYPES[$RANDOM % ${#TYPES[@]}]} 
    	echo "Einzelner Akkord ($STYLE_NAME): $ROOT$TYPE" #gibt Akkord, Genrenamen und Grundton+Typ wieder
else
    	# Akkordprogression
	read -p "Wie viele Akkorde in der Progression? " LENGTH
    	LENGTH="${LENGTH//$'\r'/}" #Carriage return entfernt
    	if ! [[ "$LENGTH" =~ ^[0-9]+$ ]] || [[ "$LENGTH" -lt 1 ]]; then #prüft ob gültige Zahl ist (also 0-9 und größer als 0)
        	echo "Ungültige Zahl"
        	exit 1 #wenn Fehler, Skript beendet
    	fi

	echo "Akkord-Progression ($STYLE_NAME):"
    	PROGRESSION=""
    	for ((i=1;i<=LENGTH;i++)); do #Schleife von 1 bis LENGTH
		#für jeden Akkord zufälliger Grundton und Typ gewählt bis gewünschte Länge erreicht
        	ROOT=${ROOTS[$RANDOM % ${#ROOTS[@]}]}
        	TYPE=${TYPES[$RANDOM % ${#TYPES[@]}]}
        	PROGRESSION+="$ROOT$TYPE " #fügt Akkord an Progression an
    	done
    	echo "$PROGRESSION" #gibt die vollst. Progression aus
fi

#Dateioperation: Akkorde mit Datum speichern

HISTORY_FILE="ChordHistory.txt"
DATUM=$(date "+%Y-%m-%d %H:%M:%S")

if [[ "$MODE" == "1" ]]; then
	echo "$ROOT$TYPE ($DATUM)" >> "$HISTORY_FILE"
else
	echo "$PROGRESSION ($DATUM)" >> "$HISTORY_FILE"
fi

echo "------------------------------------------------------"
echo "Viel Spaß!"
