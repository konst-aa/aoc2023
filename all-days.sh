#!/usr/bin/env bash

for day in {1..25}
do
    pday=$(printf %02d $day)
    if [ ! -d $pday ]
    then
        exit 0
    fi
    echo "Compiling day $day..."
    make --silent compile day=$pday
    echo "Done compiling, now running..."
    ./out
done
