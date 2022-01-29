#!/bin/bash
id="$1"
trap ctrl_c INT

function ctrl_c(){
	if [ -p "$id".pipe ]; then
		rm ./"$id".pipe
	fi
	exit 0
}

if [ $# -ne 1 ]; then
	echo 'Error: parameter problem'>&2
	exit 1
fi
mkfifo "$id".pipe
while true; do
	read r1 r2 r3 r4
	if [ -p "server.pipe" ]; then
	case "$r1" in
		create_database)
			echo "$r1 $id $r2" > server.pipe
			;;
		create_table)
			echo "$r1 $id $r2 $r3 $r4" > server.pipe
			;;
		insert)
			echo "$r1 $id $r2 $r3 $r4" > server.pipe
			;;
		select)
			echo "$r1 $id $r2 $r3 $r4" > server.pipe
			;;
		shutdown)
			echo "shutdown" "$id" > server.pipe
			;;
		exit)
			rm ./"$id".pipe
			exit 0
			;;
		*)
			echo "error" "$id" > server.pipe
			;;
	esac
	#the message that will be displayed
	firstLine=$(head -n1 "$id".pipe)
	if [ "$firstLine" = "start_result" ]; then
	 	while read input; do
			if [ "$input" != "end_result" ]; then
				echo "$input"
			fi
		done < "$id".pipe
	else
		firstWord=$(echo "$firstLine" | head -n1 | cut -d" " -f1)
		if [ "$firstWord" = "Error:" ]; then
			echo "command didn't successfully executed"
		elif [ "$firstWord" = "OK:" ]; then
			echo "command successfully executed"
		fi
		echo "$firstLine"
	fi
fi
done
exit 0
