# lamp

A simple bash script that plays mp3 and ogg files. It's fronend to mpg123
and ogg123. 


## Synopsis

```
usage: lamp.sh [-t] FILE &

Plays audio FILE (in mp3 or ogg format). It's needed run with ampersand (&) for
execute it in background.  Optionally, if -t argument is specified, than FILE 
is played in loop.

positional arguments:
  FILE           mp3 or ogg audio file

optional arguments:
  -t            play FILE in loop
```


## Usage examples

1. Play one audio file

        $ ./lamp.sh music.mp3 &

2. Play one audio file in loop

        $ ./lamp.sh -t music.mp3 &

3. Play audio files in directory DIR

        $ ./lamp.sh DIR/*.mp3 &

4. Play audio files in directory DIR in loop

        $ ./lamp.sh -t DIR/*.mp3 &

5. Making `lamp.sh` globally accessible:

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
