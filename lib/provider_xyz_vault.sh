#!/usr/bin/env bash
# 
# Azure Key Vault plugin

# To use this plugin set the following variables in _keystore.config file in your home folder
# provider="azure_keyvault"
# azure_vault_name="MY-VAULT-NAME-HERE"

add() {
  echo ""
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "...command requires 2 parameters, the password name and the actual password (or GEN to generate one) "
  else
    # replace _ with - since _ is not a valid Azure key vault secret name
    name=${1//_/-}
    echo "az keyvault secret set --vault-name $azure_vault_name --name $name --value $2"
    az keyvault secret set --vault-name "$azure_vault_name" --name "$name" --value "$2"
    echo $result
  fi
  echo ""
}

change() {
  echo ""
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "...command requires 2 parameters, the password name and the actual password (or GEN to generate one) "
  else
    # replace _ with - since _ is not a valid Azure key vault secret name
    name=${1//_/-}
    echo "az keyvault secret set --vault-name $azure_vault_name --name $name --value $2"
    az keyvault secret set --vault-name "$azure_vault_name" --name "$name" --value "$2"
    echo $result
  fi
  echo ""
}

delete() {
  echo ""
  if [ -z "$1" ]; then
    echo "...command requires 1 parameter, the password name "
  else
    # replace _ with - since _ is not a valid Azure key vault secret name
    name=${1//_/-}
    echo "az keyvault secret delete --name $name --vault-name $azure_vault_name"
    az keyvault secret delete --name "$name" --vault-name "$azure_vault_name"
  fi
  echo ""
}

get() {
  echo ""
  if [ -z "$1" ]; then
    echo "...command requires 1 parameter, the password name "
  else
    # replace _ with - since _ is not a valid Azure key vault secret name
    name=${1//_/-}
    echo "az keyvault secret show --name $name --vault-name $azure_vault_name"
    az keyvault secret show --name "$name" --vault-name "$azure_vault_name"
  fi
  echo ""
}

