#!/bin/bash

if [ $# -ne 3 ];then
	echo "Error: parameter problem"
	exit 1
fi

if [ ! -d ./$1 ]; then
	echo 'Error: DB does not exist'
	exit 1
fi

if [ -f ./$1/$2 ]; then
	echo 'Error: table already exists'
	exit 1
fi

./P.sh "$2"
cd "$1"
touch "$2"
echo "$3" > "$2"
echo "OK: table created"
cd ../
./V.sh "$2"
exit 0
