#!/usr/bin/env bash
# 
# 

source ${script_path//\/keystore/\/lib\/_cursor_menus.sh}

# Check for keystore.txt file in current directory, if not there create it 
KEYSTORE_FILE=./.keystore
key_names=()
touch $KEYSTORE_FILE
menu_items=("1. Add new password item" "2. Change password" "3. Show password" "4. Delete password" "0. Quit")
pass_gen_menu_items=("Enter my own password" "Generate a random password")
item=0

load_from_file

# Save screen
tput smcup

status_line_height=2
lines=$(tput lines)
menu_bottom_row=$((${#menu_items[@]} + 2))
body_top_row=$((${#menu_items[@]} + 3))
status_line_top_row="$(($lines - $status_line_height))"
body_bottom_row=$((${status_line_top_row} - 1))

status_line ">"

# Display menu until selected_option == 0
while [[ selected_option != 0 ]]; do

  clear_body
  
  # position and print menu separator then reset cursor to top 
  tput cup $menu_bottom_row 0
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo "   Existing passwords"
  echo "   -------------------"
  for i in "${secrets[@]}"; do
    echo "   $i"
  done  

  tput cup 0 0
  
  # print main menu
  echo "   Please Select:"
  echo 
  select_option "${menu_items[@]}"
  selected_option=$?
  status_line "> ${menu_items[$selected_option]}"
 
  # Act on selection
  case $selected_option in
    0)  tput cup $body_top_row 0
        clear_body
        echo ""
        read -p "Enter the name of the new password: " 
        pass_name=${REPLY}
        status_line "> Creating password: $pass_name"
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
        status_line "> Your password: ${pass}"
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
        status_line "> You change password ${pass}"
        change "${key_names[$choice]}" "$pass"
        ;;
    2)  tput cup $body_top_row 0
        clear_body
        echo "Select the password item to show:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        get "${key_names[$choice]}"
        status_line "> show password ${key_names[$choice]}"
        ;;
    3)  tput cup $body_top_row 0
        clear_body
        echo "Select the password item to delete:"
        echo  
        select_option "${key_names[@]}"
        choice=$?
        delete "${key_names[$choice]}"
        status_line "> deleted password ${key_names[$choice]}"
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

exit 0
