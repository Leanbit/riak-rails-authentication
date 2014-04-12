#!/bin/bash

NUM=0
MAX_DATA=2

while [ $NUM -lt $MAX_DATA ];do
    command=( "ab -n 100 -c 100 -p data.txt -T application/x-www-form-urlencoded \"http://localhost:9292/sessions.json\"" )

    eval $command

    let NUM=NUM+1

done
