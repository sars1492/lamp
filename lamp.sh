#!/bin/bash
#Linux Audio Media Player (LAMP)
#Version 0.5 by Bond (Juraj Szasz)
for ARG in $*
do
  if [ "$ARG" = "rep" ]; then
    REPEAT=t
  fi
done

while true
do
  for FILE in *
  do
    if [ "${FILE%%*.mp3}" = "$NULL" ]; then
      mpg123 -q "$FILE" 2> /dev/null 
    elif [ "${FILE%%*.ogg}" = "$NULL" ]; then
      ogg123 -q "$FILE" 2> /dev/null 
    fi
  done
  if [ -z "$REPEAT" ]; then
    break
  fi
done
