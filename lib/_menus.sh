#!/usr/bin/env bash
# 
# 

#source ${script_path//\/keystore/\/lib\/_cursor_menus.sh}

key_names=()

menu_items=("1. Add new password item" "2. Change password" "3. Show password" "4. Delete password" "0. Quit")
pass_gen_menu_items=("Enter my own password" "Generate a random password")

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
  echo "   (provider=$provider)   "
  select_option "${menu_items[@]}"
  selected_option=$?
  status_msg "${menu_items[$selected_option]}"
 
  # act on main menu selection
  case $selected_option in
    0)  tput cup $body_top_row 0
        clear_body
        echo ""
        read -p "Enter the name of the new password: " 
        pass_name=${REPLY}
        status_msg "Creating password: $pass_name"
        echo ""
        select_option  "${pass_gen_menu_items[@]}"
        choice=$?
        if [ "$choice" -eq 1 ]; then
          read -p "Enter password length [32]: " pass_length
          pass_length=${pass_length:-32}
          pass="$(gen_password -n $pass_length)"
        else
          read -p "Enter the password or key value: " 
          pass=${REPLY}
        fi
        status_msg "Your password: ${pass}"
        # add item to db
        add "${pass_name}" "${pass}"
        # append to file
        echo $pass_name >> $KEYSTORE_FILE
        load_from_file
        ;;
    1)  tput cup $body_top_row 0
        clear_body
        echo "Select the password item to change:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        select_option  "${pass_gen_menu_items[@]}"
        sub_menu_choice=$?
        if [ "$sub_menu_choice" -eq 1 ]; then
          read -p "Enter password length [32]: " pass_length
          pass_length=${pass_length:-32}
          pass="$(gen_password -n $pass_length)"
        else
          read -p "Enter the password or key value: " 
          pass=${REPLY}
        fi
        status_msg "You change password ${pass}"
        change "${key_names[$choice]}" "$pass"
        ;;
    2)  tput cup $body_top_row 0
        clear_body
        echo "Select the password item to show:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        get "${key_names[$choice]}"
        status_msg "Show password ${key_names[$choice]}"
        ;;
    3)  tput cup $body_top_row 0
        clear_body
        echo "Select the password item to delete:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        delete "${key_names[$choice]}"
        status_msg "Deleted password ${key_names[$choice]}"
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
