#!/bin/bash

file="/var/log/haproxy-access.log"

get_Xends () {
	frontends="$(cat $file | awk '{ print $3 }' | grep -v "stopped" | sort -r | uniq)"
	backends="$(cat $file | awk '{ print $4 }' | grep "/" | grep -v "$frontends" | cut -f1 -d"/" | sort | uniq)"
}

if [ ! -z "${!#}" ] && [ -f "${!#}" ];
then
	if [ "$(file ${!#})" == "ASCII text, with very long lines" ];
	then
		file="${!#}"
	fi
fi

if [ -z $1 ] || [ "$1" == "help" ];
then
	echo -e "Usage:\ngeo <backend> [<logfile>] - geo stat by backend\ngeo report ["backends" (space separated)] - generate daily report by backends [<logfile>]\ngeo list [<logfile>] - list frontends and backends\n"
elif [ "$1" == "list" ]
then
#	frontends="$(cat $file | awk '{ print $3 }' | grep -v "stopped" | sort -r | uniq)"
	get_Xends
	echo -e "Frontends:\n$frontends\n"
	echo -e "Backends:\n$backends\n"
#	cat $file | awk '{ print $4 }' | grep "/" | grep -v "$frontends" | cut -f1 -d"/" | sort | uniq
#	echo -e "\n"
elif  [ "$1" == "report" ]
then
	echo  -e "Daily report by backends\n"
	if [ -z "$2" ] || [ "$2" == "${!#}" ] ;
	then
		#frontends="$(cat $file | awk '{ print $3 }' | grep -v "stopped" | sort -r | uniq)"
		get_Xends
#		backends="$(cat $file | awk '{ print $4 }' | grep "/" | grep -v "$frontends" | cut -f1 -d"/" | sort | uniq)"
	else
		backends="$2"
	fi
	for backend in $backends
	do
		echo "Backend: $backend"
		grep "$(LANG=en_EN date +"%d\/%b\/%Y")" $file | grep $backend | awk '{ print $1 }' | cut -f1 -d":" | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | xargs -r -n 1 geoiplookup { } | cut -f2 -d":" |sort | uniq -c | sort -k1 -n -r | head -n 10
		echo
	done


else
	echo "Requests from file $file"
	grep $1 $file | awk '{ print $1 }' | cut -f1 -d":" | xargs -n 1 geoiplookup { } | cut -f2 -d":" | sort | uniq -c | sort -k1 -n -r
fi
