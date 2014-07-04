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
# sudo ln -s /home/jhr/myEnv/screener/screener.sh /usr/local/bin/screener
#

#Sed matches, deletes lines that don't have screens
del_no_sockets='/^No Sockets found.*/d'
del_screens_on='/.*screens? on:.*/d'
del_num_sockets='/[0-9]+ Sockets? in /d'
del_blank_lines='/^\s+$/d'

#reformats the screens to what's seen in the menu
get_screens='s/\s+([^.]+)\.(\S+?).*/\2(\1)/'

#concat the previous
sed_string="$del_no_sockets;$del_screens_on;$del_num_sockets;$del_blank_lines;$get_screens"

#Used to join the lines and separate them by a space.
del_newlines=':a;N;$!ba;s/\n/ /g'

#Execute!
MYSCREENS=$(screen -ls | sed -E "$sed_string" | sed "$del_newlines")


MODE="DETACH"
MODEFLAG="-D -R"
whichMode() {
  if [[ "$MODE" == 'DETACH' ]]; then
    echo "Toggle Mode(DETACH/ATTACH)"
  else
    echo "Switch to: DETACH & REATTACH (-D -R)"
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

PS3="Option #) "

echo -e
echo "Defaults to 'screen -D -R ...'"
echo -e
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
        "Toggle Mode"* )
          if [[ "$MODE" == "DETACH" ]]; then
            echo "Switched to attach (multiuser) mode (screen -x)"
            MODE="ATTACH"
            MODEFLAG="-x"
          else
            echo "Switched to detach mode (screen -D -R)"
            MODE="DETACH"
            MODEFLAG="-D -R"
          fi
          continue;

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

#screen -D -R $finalScreenName
scrCMD="screen ${MODEFLAG} $finalScreenName"

eval "$scrCMD"
#screen "${MODEFLAG} $finalScreenName
echo "Executed: $scrCMD"

echo "Thank you for using Screener!!"
