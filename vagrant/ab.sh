#!/bin/bash
 
NUM=0
MAX_DATA=5
 
while [ $NUM -lt $MAX_DATA ];do
    command=( "ab -n 10000 -c 100 -p data$NUM -T application/x-www-form-urlencoded http://localhost:3000/users" )
 
    eval $command   
 
    let NUM=NUM+1
 
done