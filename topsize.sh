#!/bin/bash

n=0
marker=0
markers=0
markerh=""
markerhelp=0
dir="."
minsize=1
for var in "$@"
	do

	if [[ "$var" == "--" ]]
	then
		marker=1
	elif [[ $marker == 0 ]] && [[ "$var" == "-s" ]] 
	then
		markers=1
	elif [[ $markers == 1 ]]
	then
		minsize=$var
		markers=2

		if [[ `echo $minsize | grep -E "[^0-9]+"` ]]
		then
			echo size is not a number >&2
			exit 2
		fi

	elif [[ $marker == 0 ]] && [[ "$var" == "-h" ]]
	then
		markerh="-h"
	elif [[ $n == 0 ]] && [[ $marker == 0 ]] && [[ `echo $var | cut -c 1` == "-" ]] && ! [[ `echo $var | cut -c 2- |  grep -E "[^0-9]+"` ]]
	then	
		n=$var
	elif [[ $marker == 0 ]] && [[ "$var" == "--help" ]] 
	then
		markerhelp=$var
	elif [[ $marker == 0  ]] && [[ "$var" == "-*" ]]
	then
		echo option does not exist >&2
	else
		dir=$var

		fi
done
if [[ $markerhelp == 1 ]] 
then
	echo команда выводит отсортированный список файлов из директории и всех ее подтерикторий
	echo -s size : вывести файлы должны быть размера не меньше size
	echo -h : вывести в человекочитаемом виде
	echo -n : вывести первые n файлов


	exit 0
fi

if [[ $n == 0 ]]
then
	find $dir -type f -size +"$minsize"c -exec du $markerh {} + | sort -nr 
else
	find $dir -type f -size +"$minsize"c -exec du $markerh {} + | sort -nr | head $n
	
fi


exit 0
