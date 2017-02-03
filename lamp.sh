#!/bin/bash
#Linux Audio Media Player (LAMP)
#Version 0.5 by Bond (Juraj Szasz)

if [ ! -e ~/.lamp/pid ]; then		#make new pidfile
  mkdir ~/.lamp/
  echo $$ > ~/.lamp/pid
fi
PID=`cat < ~/.lamp/pid`			#read old pid
echo $PID

#Read Arguments
for ((NARG=1; NARG<=$#; NARG++))
do
  if [ "${!NARG}" = "-r" -o "${!NARG}" = "repeat" ]; then
    REPEAT=t
    OLDLIST=t
  elif [ "${!NARG}" = "-rt" -o "${!NARG}" = "repeat-track" ]; then
    REPTRACK=t
    OLDLIST=t
  elif [ "${!NARG}" = "-f" -o "${!NARG}" = "foward" ]; then
    FOWARD=t
    OLDLIST=t
  elif [ "${!NARG}" = "-b" -o "${!NARG}" = "backward" ]; then
    BACKWARD=t
    OLDLIST=t
  elif [ "${!NARG}" = "-sh" -o "${!NARG}" = "shufle" ]; then
    SHUFLE=t
    OLDLIST=t
  elif [ "${!NARG}" = "-p" -o "${!NARG}" = "pause" ]; then
    if [ "`ps --no-headers -O -p $PID |  gawk '{ print $3 }' -`" = "T" ]; then
      kill -CONT -$PID &> /dev/null
    else
      kill -STOP -$PID &> /dev/null 
    fi
    exit
  elif [ "${!NARG}" = "-s" -o "${!NARG}" = "stop" ]; then
    kill -- -$PID 
    rm -fr ~/.lamp/
    exit
  elif [ "${!NARG}" = "-h" -o "${!NARG}" = "help" ]; then
    echo "Použitie: lamp [nastavenia] &"
    echo "-t n, track n			skociť na n-tú skladbu"
    echo "-f, foward			skociť na naskedujúcu skladbu"
    echo -e "-b, backward		\tskociť na prechádzajúcu skladbu"
    echo "-s, stop			zastaviť prehrávanie"
    echo "-p, pause			prerusiť prehrávanie"
    echo "-g, gain n			nastaviť hlasitosť na n (v percentách)"
    echo "-r, repeat			opakovať zvolené skladby"
    echo "-rt, repeat-track		opakovať určitú skladbu"
    echo "-sh, shufle			nahodne hrať zvolené skladby"
    echo -e "-o, open SÚBOR		\tčítať playlist zo SÚBORu"
    echo -e "-w, write SÚBOR		\tzapísať playlist do SÚBORu"
    echo -e "-d, directory ADRESÁR	\thrať v ADRESÁRi"
    exit
  elif [ "${!NARG}" = "-d" -o "${!NARG}" = "directory" ]; then
    shift
    cd "${!NARG}"
  elif [ "${!NARG}" = "-t" -o "${!NARG}" = "track" ]; then
    shift
    TRACK=${!NARG}
    OLDLIST=t
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
#echo a

play() {
  
  FILE=$1
  REPTRACK=$2

  while true
  do
    echo 11
    #echo "$FILE"
    if [ "${FILE%%*.mp3}" = "$NULL" ]; then
      mpg123 -q "$FILE" 2> /dev/null
    elif [ "${FILE%%*.ogg}" = "$NULL" ]; then
      ogg123 -q "$FILE" 2> /dev/null 
    fi
    if [ -z "$REPTRACK" ]; then
      break
    fi
  done
}

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



#Kill old instances
if [ -n "`ps x | grep 'mpg123\|ogg123' | grep -v grep`" -o -n "`ps x | grep $PID | grep -v grep`" ]; then
  #echo 2
  kill -- -$PID && killall -wq ogg123 
  if [ -z "$RLIST" -a -z "$OLDLIST" ]; then
    rm -fr ~/.lamp
  fi
fi
echo $$ > ~/.lamp/pid				#Write new PID	

#echo b
#Playing iteration
while true
do
  echo c
  #echo $RLIST
  #echo $WARD
  if [ ! -e "$RLIST" -a -n "$RLIST" ]; then	#If Playlist non-exsist
    echo lamp: súbor $RLIST neexistuje
    exit
  elif [ -z "$RLIST" -a -z "$OLDLIST" ]; then
    #echo list
    ls | grep 'mp3$\|ogg$' | list -w ~/.lamp/playlist
    RLIST=~/.lamp/playlist
  elif [ -e ~/.lamp/playlist ]; then
    RLIST=~/.lamp/playlist
    #echo e
  elif [ -n "$RLIST" ]; then
    cat "$RLIST" > ~/.lamp/playlist
  fi

  #cat $RLIST
  #If track aren't in local directory
  if [ "`cat $RLIST`" = "$PWD/mp3" ]; then
    echo "lamp: V lokálnom adresári nie sú žiadne ogg-y alebo mp3-ky"
    echo "Presuňte sa do adresara s príslušnými súbormi alebo"
    echo "použite Playlist prikazom \`lamp -o Playlist'"
    exit
  fi

  #echo $RLIST
  MAX=`list -l "$RLIST"`
  MAX=`expr $MAX + 1`
  for ((I=1; I<=$MAX; I++))
  do
    #echo 8
    #echo $REPEAT
    FILE="`list -r "$RLIST" $I`"
    #echo I$I
    #echo "$FILE"
    if [ -e ~/.lamp/track ]; then
      TR=`cat ~/.lamp/track`
    else
      touch ~/.lamp/track
      TR=1
      echo track
    fi
    #echo R$TR
    if [ -n "$SHUFLE" ];then
      TRACK=`list -s ~/.lamp/seed $MAX`
    elif [ -n "$FOWARD" ];then
      TRACK=`expr $TR + 1`
    elif [ -n "$BACKWARD" ];then
      TRACK=`expr $TR - 1`
    fi
    #echo T$TRACK

    #Repeat session
    if [ -n "$REP" -a -z "$TRACK" ];then
      TRACK=$TR
    fi

    if [ ! -e "$FILE" ];then
      echo "súbor $FILE neexistuje"
      echo "Pozrite či ste v playliste neurobili chybu"
      exit
    elif [ -z "$TRACK" ];then
      TRACK=1
      play "$FILE" $REPTRACK
    elif [ $I -lt $TRACK ]; then
      continue
    else
      echo $I > ~/.lamp/track
      play "$FILE" $REPTRACK
    fi
  done

  if [ -z "$REPEAT" ]; then
    #echo 6
    break
  fi
done

rm -fr ~/.lamp
