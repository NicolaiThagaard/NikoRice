#!/bin/bash
I=0
mkdir $1
cd $1
while true
do 
	mkdir $I
	let "I++"
	echo $I
done
