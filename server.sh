#!/bin/bash
trap ctrl_c INT

function ctrl_c(){
	if [ -p server.pipe ]; then
		rm ./server.pipe
	fi
	exit 0
}

mkfifo server.pipe
while true; do
read v1 id v2 v3 v4 < server.pipe
if [ -p "$id.pipe" ]; then
case "$v1" in
	create_database)
		./create_database.sh "$v2" > "$id".pipe &
		;;
	create_table)
		echo $(./create_table.sh "$v2" "$v3" "$v4") > "$id".pipe &
		;;
	insert)
		echo $(./insert.sh "$v2" "$v3" "$v4") > "$id".pipe &
		;;
	select)
		if [ "$v4" = "" ]; then
			./select.sh "$v2" "$v3" > "$id".pipe &
		else
			./select.sh "$v2" "$v3" "$v4" > "$id".pipe &
		fi
		;;
	shutdown)
		rm ./server.pipe
		exit 0
		;;
	*)
		echo 'Error: bad request' > "$id".pipe &
		;;
esac
fi
done




