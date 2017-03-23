#!/bin/bash

printf "Executing "

case $1 in
	"ej1" )
		# Recognizes all dates of the form DD/MM/YYYY
		echo 'grep -E "\b(0[1-9]|(1|2)\d|3[01])/(0[1-9]|1[012])/\d{4}\b"'
		grep -E "\b(0[1-9]|(1|2)\d|3[01])/(0[1-9]|1[012])/\d{4}\b" $2 ;;
	"ej2ar" )
		# Changes Spanish infinitive verbs to third person singular past tense
		echo 'sed -E "s\/\b(\w*)ar\b\/\1ó\/g"'
		sed -E "s/\b(\w*)ar\b/\1ó/g" $2 ;;
	"ej2erir" )
		echo 'sed -E "s/\b(\w*)(er|ir)\b/\1ió/g"'
		sed -E "s/\b(\w*)(er|ir)\b/\1ió/g" $2 ;;
	"ej3" )
		# "Parses" any csv file
		echo 'pcregrep -M "^(([^\",\t\n\r^$]*|\"(\"{2}|[^\"]|\s|^|$)*\")?($|,))*$"'
		pcregrep -M "^(([^\",\t\n\r^$]*|\"(\"{2}|[^\"]|\s|^|$)*\")?($|,))*$" $2 ;;
	"ej4" )
		# Changes http to https and .net to .com
		echo 'sed -E "s/https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)/https:\/\/\1\.com\6/g"'
		sed -E "s/https?:\/\/((www\.)?([^n][^e][^t])*?[^\.]+(\.[^n][^e][^t])?)(\.net)?([\w\-\/~\.@=%&_?]*)/https:\/\/\1\.com\6/g" $2 ;;
	"ej5a" )
		# CSV file cleaning: from uppercase to lowercase
		echo 'sed -E -e "s/(.*),/\L\1,/"'
		sed -E "s/(.*),/\L\1,/" $2 ;;
	"ej5b" )
		# CSV file cleaning: adds a period at the end of what's matched before first comma
		echo 'sed -E "s/(\")?(.*)([^\.])(\")?,(.*),(.*)/\1\2\3\4\.,\5,\6/g"'
		sed -E "s/(\")?(.*)([^\.])(\")?,(.*),(.*)/\1\2\3\4\.,\5,\6/g" $2 ;;
	"ej5c" )
		# CSV file cleaning
		echo 'sed -E "s///g"'
		sed -E "s/(\")?(.*)([\n\r ]*)(\")?,(.*),(.*)/\1\2\4\.,\5,\6/g" $2 ;;
	"ej5d" )
		# CSV file cleaning
		echo 'sed -E "s///g"'
		sed -E "s/(\")?(.*)(\.\.)(.*)(\")?,(.*),(.*)/\1\2\4\5\.,\6,\7/g" $2 ;;
	* )
		echo "ERREUR" ;;
esac
