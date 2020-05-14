#!/usr/bin/env bash
# 
# 

#source ${script_path//\/keystore/\/lib\/_cursor_menus.sh}

key_names=()

menu_items=("1. Add new secret item" "2. Change selected secret item" "3. Show selected items secret value" "4. Delete selected secret item" "0. Quit")
pass_gen_menu_items=("Enter my own secret/password value" "Generate a random secret/password value")

# load secret password variable names from local .keystore file
load_from_file

status_msg_line_height=2
last_status_line1_message=""
last_status_line2_message=""
lines=$(tput lines)
menu_bottom_row=$((${#menu_items[@]} + 2))
body_top_row=$((${#menu_items[@]} + 3))
status_line_top_row="$(($lines - $status_msg_line_height))"
body_bottom_row=$((${status_line_top_row} - 1))

# display menu until break is encountered
while true; do

  # reset ui
  clear_header
  clear_body
  status_msg "${last_status_line1_message}" "${last_status_line2_message}"
  
  # print default body and home the cursor
  print_default_body
  tput cup 0 0
  
  # print main menu
  echo "   Please Select:"
  echo "   (provider:$provider) (namespace:\"$namespace\")   "
  select_option "${menu_items[@]}"
  selected_option=$?
  status_msg "${menu_items[$selected_option]}"
 
  # act on main menu selection
  case $selected_option in
    0)  tput cup $body_top_row 0
        clear_body
        echo ""
        echo "Secret item names are namespaced to this project directory.  The namespace is prefixed "
        echo "to the front of secret item names.  This full namespaced name appears ONLY in the key store."
        echo
        read -p "Enter the name of the new secret item: " 
        pass_name=${REPLY}
        status_msg "Creating secret item: $pass_name"
        echo ""
        select_option  "${pass_gen_menu_items[@]}"
        choice=$?
        if [ "$choice" -eq 1 ]; then
          read -p "Enter secret/password length or accept the default [32]: " pass_length
          pass_length=${pass_length:-32}
          pass="$(gen_password -n $pass_length)"
        else
          read -p "Enter the secret/password or key value: " 
          pass=${REPLY}
        fi
        status_msg "Entered secret value: ${pass}"
        # add item to db
        add "${namespace}${pass_name}" "${pass}"
        # append to file
        echo $pass_name >> $KEYSTORE_FILE
        load_from_file
        ;;
    1)  tput cup $body_top_row 0
        clear_body
        echo "Select the secret item to change:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        select_option  "${pass_gen_menu_items[@]}"
        sub_menu_choice=$?
        if [ "$sub_menu_choice" -eq 1 ]; then
          read -p "Enter secret/password length or accept the default [32]: " pass_length
          pass_length=${pass_length:-32}
          pass="$(gen_password -n $pass_length)"
        else
          read -p "Enter the secret/password or key value: " 
          pass=${REPLY}
        fi
        status_msg "You change secret item: ${pass}"
        change "${namespace}${key_names[$choice]}" "$pass"
        ;;
    2)  tput cup $body_top_row 0
        clear_body
        echo "Select the secret item to show:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        get "${namespace}${key_names[$choice]}"
        status_msg "Show secret: ${key_names[$choice]}"
        ;;
    3)  tput cup $body_top_row 0
        clear_body
        echo "Select the secret item to delete:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        delete "${namespace}${key_names[$choice]}"
        status_msg "Deleted secret item: ${key_names[$choice]}"
        unset 'key_names[$choice]'
        save_keys_to_file
        load_from_file
        ;;
    4)  break
        ;;
    *)  echo "Invalid entry."
        ;;
  esac
  printf "\n\nPress any key to continue."

  read -n 1
done
clear

exit 0
