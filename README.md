# lamp

A simple bash script that plays mp3 and ogg files in local directory or from
playlist. It's frontend to mpg123 and ogg123.


## Synopsis

```
usage: lamp.sh [-r] [-rt] [-s] [-h] [-p] [-g] [-o] [-w] &

Plays audio FILEs (in mp3 or ogg format) in local directory. It's needed run
with ampersand (&) for execute it in background.  

optional arguments:
  -r, -repeat         play files in loop
  -rt -repeat-track   play actual file in loop
  -s -stop            stop playing actual file
  -s -stop            terminate program
  -h -help            show help in slovak language
  -p N -play N        jump to N track in playlist
  -g N -gain N        change volume to N (in percent)
  -g FILE -open FILE  open playlist from FILE
  -w FILE -wite FILE  write playlist to FILE
```


## Usage examples

1. Play files in local directory

        $ ./lamp.sh &


2. Making `lamp.sh` globally accessible:

        $ cp lamp.sh ~/bin
        $ export PATH=$PATH:~/bin


## License

lamp.sh -- Plays mp3 and ogg audio files.

Copyright (C) 2003  Juraj Szasz (<juraj.szasz3@gmail.com>)

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hopet hat it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.
