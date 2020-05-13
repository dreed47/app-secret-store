#!/usr/bin/env bash
# 
# MacOS KeyChain plugin

password_type="custom app secrets"

add() {
  echo ""
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "...command requires 2 parameters, the password name and the actual password (or GEN to generate one) "
  elif [ $2 = "GEN" ]; then
    pass=$(pwgen)
    echo "security add-generic-password -a ${USER} -s $1 -w $pass -U -D $password_type"
    security add-generic-password -a ${USER} -s $1 -w $pass -U -D "$password_type"  
  else
    echo "security add-generic-password -a ${USER} -s $1 -w $2 -U -D $password_type"
    security add-generic-password -a ${USER} -s $1 -w $2 -U -D "$password_type"
    echo $result
  fi
  echo ""
}

change() {
  echo ""
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "...command requires 2 parameters, the password name and the actual password (or GEN to generate one) "
  elif [ $2 = "GEN" ]; then
    pass=$(pwgen)
    echo "security add-generic-password -a ${USER} -s $1 -w $pass -U -D $password_type"
    security add-generic-password -a ${USER} -s $1 -w $pass -U -D "$password_type"  
  else
    echo "security add-generic-password -a ${USER} -s $1 -w $2 -U -D $password_type"
    security add-generic-password -a ${USER} -s $1 -w $2 -U -D "$password_type"
    echo $result
  fi
  echo ""
}

delete() {
  echo ""
  if [ -z "$1" ]; then
    echo "...command requires 1 parameter, the password name "
  else
    echo "security delete-generic-password -a ${USER} -s $1"
    security delete-generic-password -a ${USER} -s $1 
  fi
  echo ""
}

get() {
  echo ""
  if [ -z "$1" ]; then
    echo "...command requires 1 parameter, the password name "
  else
    echo "security find-generic-password -a ${USER} -s $1 -w"
    security find-generic-password -a ${USER} -s $1 -w
  fi
  echo ""
}

