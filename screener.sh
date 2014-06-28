#!/bin/bash
#
# Menu driven interface for reattaching to screens
#
# I wanted a way to see all the screens I have open so I can reattach to a
# specific project.
#
# I have aliases in my bash_aliases like "alias sdr='screen -D -R someproject'"
#
# This alias automatically names the screen and creates it if it doesn't exist.
#
# @todo Store screenrc files in same directory and automatically open in
#   project's directory. screenrc file could 'grunt serve' in one window and
#   create another window that's just a shell.
#
# @todo Make it so you can choose to attach with detaching the screen session.
#    This way you can have multiuser screen sessions.
#
#

MYSCREENS=$(screen -ls | sed -E '/.*screens? on:.*/d;/[0-9]+ Sockets? in /d;/^\s+$/d;s/\s+([^.]+)\.(\S+?).*/\2(\1)/;' | sed ':a;N;$!ba;s/\n/ /g;')


#@todo
MODE="DETACH"
whichMode() {
  if [[ "$MODE" == 'DETACH' ]]; then
    echo "Switch to: ATTACH ONLY(todo)"
  else
    echo "Switch to: DETACH & REATTACH(todo)"
  fi
}
#/@todo

# 'returns' createScreenName
createScreen() {
  echo "Name of your new screen? (Alphanumeric)"
  read screenName

  if [[ "$screenName" =~ ^[[:alnum:]]+$ ]]; then
    echo "name is okay"
    createScreenName=$screenName
  else
   echo "Name should be Alphanumeric only; Try again"
   createScreenName="Fail"
   #createScreen
  fi
}

select screen in "CREATE" $MYSCREENS "$(whichMode)" "Exit"; do
#select screen in "one" "two" "thre" "four" "five" "six" "seven" "eight" "nine"; do
    case $screen in
        "CREATE" )
          createScreen
          if [[ "$createScreenName" != "Fail" ]]; then
           finalScreenName="$createScreenName"
           break;
          fi
          ;;
        "Switch to"* )
          echo "Switch to"
          break
          ;;
        "Exit" )
          echo -e
          echo "Okay, Exiting... "
          echo -e
          break
          ;;
        *)
          echo -e
          echo "You chose: $screen"
          finalScreenName=`sed -E 's/.*\(([[:digit:]]+)\)/\1/g' <<< $screen`
          break
          ;;
    esac
done

echo screen -D -R $finalScreenName
screen -D -R $finalScreenName

echo "Thank you for using Screener!!"
