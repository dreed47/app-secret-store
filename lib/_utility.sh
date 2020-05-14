#!/usr/bin/env bash
#
#

create_default_config() {
    clear
    provider_list=()
    for f in $(find $script_path/lib -name 'provider_*.sh'); do
        fname=$(basename $f)
        fname=${fname/provider_/}
        #echo ${fname/.sh/};
        provider_list+=("${fname/.sh/}")
    done
    echo "Select the key store provider you wish to use in this project:"
    echo
    select_option "${provider_list[@]}"
    selected_option=$?
    echo "${provider_list[$selected_option]}"
    
    touch $1
    
    echo "# Enable/disable desired key store provider and associated variables." >> $1
    echo >> $1
    for i in "${provider_list[@]}"
    do
        if [ $i ==  ${provider_list[$selected_option]} ]; then
            echo "provider=\"$i\"" >> $1
        else
            echo "# provider=\"$i\"" >> $1
        fi
    done
    
    namespace=${PWD##*/}
    namespace=${namespace/./-}
    namespace=${namespace/_/-}
    namespace="${namespace}-"
    namespace=$(echo "$namespace" | tr '[:lower:]' '[:upper:]')
    read -e -p "Please enter a namespace identifier [$namespace]: " input
    namespace="${input:-$namespace}"
    echo >> $1
    echo "namespace=\"$namespace\"" >> $1
    echo >> $1
    echo "# If you're using MacOS Keychain you can override the password type or let it default." >> $1
    echo "# macos_keychain_password_type=\"custom app secrets\"" >> $1
    echo >> $1
    echo "# If you're using Azure Key Vault enter your vault name below." >> $1
    echo "# azure_vault_name=\"MY-VAULT-NAME-HERE\"" >> $1


}

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

clear_header() {
    
    tput sc
    tput cup 0 0
    for (( c=0; c<=$menu_bottom_row; c++ )); do
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


print_default_body() {
    tput sc
    # position and print menu separator
    tput cup $menu_bottom_row 0
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "   Existing passwords found in the current folder"
    echo "   ----------------------------------------------"
    for i in "${secrets[@]}"; do
        echo "   $i"
    done
    tput rc
}


status_msg() {
    
    last_status_line1_message=$1
    last_status_line2_message=$2
    tput sc
    tput cup $status_line_top_row 0
    echo -n ${BG_STATUS_LINE}${FG_STATUS_LINE}
    tput ed
    echo -n "> "
    echo -n $1
    tput cud1
    echo -n "> "
    echo -n $2
    
    tput rc
    echo -n ${BG_BODY}${FG_BODY}
    
}
