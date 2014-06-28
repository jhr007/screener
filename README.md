screener
========

Menu for GNU screen to reattach to running screens. 

Creates a menu for `screen -ls`

ex: 

```
$ ./screener.sh
1) CREATE                        5) Awesomeo(5113)
2) SomeOtherProject(21036)       6) Switch to: ATTACH ONLY(todo)
3) Funtimes(20979)               7) Exit
4) sweetProject(20880)
```

instead of 

```
$ screen -ls
There are screens on:
        21036.SomeOtherProject  (06/28/2014 05:48:19 AM)        (Detached)
        20979.Funtimes  (06/28/2014 05:48:07 AM)        (Detached)
        20880.sweetProject      (06/28/2014 05:47:44 AM)        (Detached)
        5113.Awesomeo     (04/19/2014 01:14:35 PM)        (Detached)
4 Sockets in /var/run/screen/S-usr.

$ screen -D -R 21036
```
