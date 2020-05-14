#!/usr/bin/env bash
# 
# This files serves as a template to implement a new key store provider 

# any variables that need set to run the provider functions below

provider_config() {
  # Add notes, instructions or variables to the global config file 
  # e.g. echo "# Here are instructions for using the XYZ provider plugin" >> $1
  # e.g. echo "# my_variable=\"somevalue\"" >> $1
}

add() {
  # ...some command to add a new sectret item to the key store 
}

change() {
  # ...some command to change a sectret item in the key store 
}

delete() {
  # ...some command to delete a sectret item from the key store 
}

get() {
  # ...some command to show a sectret item from the key store 
}
