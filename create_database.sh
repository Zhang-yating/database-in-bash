#!/bin/bash

#check if a parameter is entered
if [  $# -eq 0 ]; then
	echo "Error: no parameter"
	exit 1
fi

#check if too many parameters
if [ $# -gt 1 ]; then
	echo "Error: Too many parameters"
	exit 1
fi


#check if a database is already exist
if [ -d ./"$1" ]; then
	echo "Error: DB already exists"
	exit 1
fi

./P.sh "$1"
mkdir "$1"
echo "OK: database created"
./V.sh "$1"
exit 0

