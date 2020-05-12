#!/usr/bin/env bash
# 
# 

gen_password() {
  num=32
  if [ x"${1}" = x"-n" ]; then
    num=$2
  fi
  #LANG=C tr -dc '[:print:]' </dev/urandom | head -c ${num}
  LANG=C tr -dc '_A-Z-a-z-0-9-!@#$%' </dev/urandom | head -c ${num}
}


clear_body() {

  tput sc
  tput cup $body_top_row 0 
  for (( c=$body_top_row; c<=$body_bottom_row; c++ )); do
   tput el
   tput cud1
  done
  tput rc

}


load_from_file() {
  key_names=()
  if [ ! -e "$KEYSTORE_FILE" ]; then
    echo ""
    echo "...Keystore file named $KEYSTORE_FILE was not found!"
    echo ""
    exit 0
  else  
    IFS=$'\n' read -d '' -r -a secrets < $KEYSTORE_FILE  
    for i in "${secrets[@]}"
    do
      #echo "app secret - $i"
      key_names+=( "$i" )
    done  
  fi

}


save_keys_to_file() {
  > $KEYSTORE_FILE
  for i in "${key_names[@]}"
  do
    echo "$i" >> $KEYSTORE_FILE
  done  

}


status_line() {

  tput sc
  tput cup $status_line_top_row 0 
  echo -n ${BG_STATUS_LINE}${FG_STATUS_LINE}  
  tput ed 
 
  echo -n $1
  tput cud1
  echo -n $2

  tput rc
  echo -n ${BG_BODY}${FG_BODY}

}
