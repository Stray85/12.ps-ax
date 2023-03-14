#!/bin/bash
echo -e "PID\tSTAT\tTTY\tCOMMAND"

stat(){
  if [ -f ${PROC}/stat ]; then
    cat ${PROC}/stat  | awk '{printf $3}' 
  else
    echo '-'
  fi
}

_tty(){
  if [ -f ${PROC}/stat ]; then
    B=`cat ${PROC}/stat | rev | awk '{printf $46}' | rev`;
    C=`bc <<< "obase=2;$B"`;
    D=`echo $C | rev`
    minor=${D:0:2}${D:4:3}
    major=${D:3:2}
    minor=`echo $minor | rev`
    major=`echo $major | rev`
    E=`echo $major$minor`
        F=`bc <<< "obase=10;ibase=2;$E"`;
    if [ $F = "0" ]; then
      echo '?';
    else
      echo tty$F;
    fi
  else
    echo '-'
  fi
}

cmd(){
  if [ -f ${PROC}/stat ]; then
  cat ${PROC}/cmdline | tr '\0' '\n' | sed -e s/DBUS_SESSION_BUS_ADDRESS=//
  else
    echo 'n/a'
  fi
}

for PROC in `ls -d /proc/* | egrep "^/proc/[0-9]+"`; do
  echo -e "${PROC/\/proc\//}\t$(stat)\t$(_tty)\t$(cmd)";
done