#!/bin/bash
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
	echo 'Error: parameters problem'
	exit 1
fi

if [ ! -d ./"$1" ]; then
	echo "Error: DB does not exist"
	exit 1
fi

if [ ! -f ./"$1"/"$2" ]; then
	echo 'Error: table does not exist'
	exit 1
fi


headco=$(head -n1 ./"$1"/"$2")

#check how many columns there are
columns=$(echo $headco | tr ',' ' ' | wc -w)

#if the number of parameters is correct
if [ $# -eq 3 ]; then
	paraNum=$(echo "$3" | tr ',' ' ' | wc -w)
	#for i in [1,len(column)],check every column index is connect or not
	for i in $(seq 1 $paraNum); do
		#the index of the column entered
		coIndex=$(echo "$3" | cut -d, -f$i)
		# if user selected 0th column or the column that doesn't exist
		if [ $coIndex -eq 0 ] || [ $coIndex -gt $columns ]; then
			echo 'Error: column does not exist'
			exit 1
		fi
	done

	./P.sh "$2"
	echo "start_result"
	#print selected columns of the file
	cut -d, -f"$3" ./"$1"/"$2"
#if no column index has been given, then display all the columns
elif [ $# -eq 2 ]; then
	./P.sh "$2"
	echo "start_result"
	cat ./"$1"/"$2"
fi
echo "end_result"
./V.sh "$2"
exit 0




