#!/bin/bash
#Linux Audio Media Player (LAMP)
#Version 0.5 by Bond (George Szasz)

PID=`cat < ~/.pid`			#Read old PID

#Read Arguments
for ((NARG=1; NARG<=$#; NARG++))
do
  if [ "${!NARG}" = "-r" -o "${!NARG}" = "repeat" ]; then
    REPEAT=t
  elif [ "${!NARG}" = "-rt" -o "${!NARG}" = "repeat-track" ]; then
    REPTRACK=t
  elif [ "${!NARG}" = "-s" -o "${!NARG}" = "stop" ]; then
    kill -- -$PID 
    exit
  elif [ "${!NARG}" = "-h" -o "${!NARG}" = "help" ]; then
    echo "Použitie: lamp [nastavenia]"
    echo "-p, play n		skociť na n-tú skladbu"
    echo -e "-s, stop		\tukončiť program"
    echo "-g, gain n		nastaviť n-tú hlasitosť (v percentách)"
    echo "-r, repeat		opakovať zvolené skladby"
    echo "-rt, repeat-trakc	opakovať určitú skladbu"
    echo -e "-o, open SÚBOR	\tčítať playlist zo SÚBORu"
    echo -e "-w, write SÚBOR	\tzapísať playlist do SÚBORu"
    exit
  elif [ "${!NARG}" = "-p" -o "${!NARG}" = "play" ]; then
    shift
    TRACK=${!NARG}
  elif [ "${!NARG}" = "-g" -o "${!NARG}" = "gain" ]; then
    shift
    aumix -w ${!NARG}
    exit
  elif [ "${!NARG}" = "-o" -o "${!NARG}" = "open" ]; then
    shift
    RLIST=${!NARG}
  elif [ "${!NARG}" = "-w" -o "${!NARG}" = "write" ]; then
    shift
    WLIST=${!NARG}
    WRITE=t
  else
    echo lamp: argument ${!NARG} neexistuje
    echo "Pozri \`lamp help' alebo \`lamp -h' pre viac informácií"
    exit
  fi
done
#echo 1

#Make new playlist
if [ -n "$WLIST" ]; then
  while list -w "$WLIST"
  do
    #echo 2
    true
  done
  exit
elif [ -n "$WRITE" ]; then
  echo "lamp: argumentu \`-w' chýba meno súboru"
  exit
fi

#If Playlist non-exsist
if [ ! -e "$RLIST" -a -n "$RLIST" ]; then
  echo lamp: súbor $RLIST neexistuje
  exit
fi

#If track aren't in local directory
if [ -z "$RLIST" -a -z "`ls | grep mp3$`" -a -z "`ls | grep ogg$`" ]; then
  echo "lamp: V lokálnom adresári nie sú žiadne ogg-y alebo mp3-ky"
  echo "Presuňte sa do adresara s príslušnými súbormi alebo"
  echo "použite Playlist prikazom \`lamp -o Playlist'"
  exit
fi

#Kill old instances
if [ -n "`ps x | grep 'mpg123\|ogg123' | grep -v grep`" -o -n "`ps x | grep $PID | grep -v grep`" ]; then
  #echo 2
  kill -- -$PID && killall -wq ogg123 
fi
echo $$ > ~/.pid			#Write new PID	

#echo 4
#Playing iteration
while true
do
  #echo 5
  #echo $RLIST
  #A=`list -r $RLIST`
  for FILE in `list -r $RLIST`
  do
    #echo "$FILE"
    #echo 6
    #echo $REPEAT
    FILE=`list -l "$FILE"`
    if [ "$TRACK" != "1" -a -n "$TRACK" ]; then
      TRACK=`expr $TRACK - 1`
      continue
    fi
    while true
    do
      if [ "${FILE%%*.mp3}" = "$NULL" ]; then
	mpg123 -q "$FILE" 2> /dev/null 
      elif [ "${FILE%%*.ogg}" = "$NULL" ]; then
	ogg123 -q "$FILE" 2> /dev/null 
      fi
      if [ -z "$REPTRACK" ]; then
	break
      fi
    done
  done
  if [ -z "$REPEAT" ]; then
    #echo 6
    break
  fi
done
