#!/usr/bin/env bash

# $Id: randomsleep.sh 2837 2009-09-06 07:17:55Z uwaechte $

#randomsleep.sh - sleeps for a random time and then returns true
MAX=600;
[ $1 ] && MAX=$1 ;

for I in 1 2 3 4 5 6 7 8 9 10; do
	  RND=$RANDOM;
done
sleep $(expr $RND % $MAX);
	
exit 0;
