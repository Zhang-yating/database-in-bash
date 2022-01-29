#!/bin/bash
if [ $# -ne 3 ]; then
	echo "Error: parameters problem"
	exit 1
fi

if [ ! -d ./$1 ]; then
	echo 'Error: DB does not exist'
	exit 1
fi

if [ ! -f ./$1/$2 ]; then
	echo "Error: table does not exist"
	exit 1
fi


columns=$(echo "$3"|tr ',' ' '|wc -w)
headline=$(head -n 1 ./$1/$2)
schemaColumns=$(echo $headline|tr ',' ' '|wc -w)
if [ $columns -ne $schemaColumns ]; then
	echo 'Error: number of columns in tuple does not match schema'
	exit 1
fi

./P.sh "$2" 
echo "$3" >> "$1"/"$2"
echo 'OK: tuple inserted'
./V.sh "$2"
exit 0

