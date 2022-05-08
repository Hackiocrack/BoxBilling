#!/bin/bash

set -e

SCRIPT_VERSION="v0.6.9"
GITHUB_BASE_URL="https://raw.githubusercontent.com/AloneX079/BoxBilling"

LOG_PATH="/var/log/boxbilling-installer.log"

#Check for sudo privileges!
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

#Check for curl installation!
if ! [ -x "$(command -v curl)" ]; then
  echo "* Curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives)"
  exit 1
fi

cd /var/log && touch boxbilling-installer.log

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

execute() {
  echo -e "\n\n* boxbilling-installer $(date) \n\n" >>$LOG_PATH

  bash <(curl -s "$1") | tee -a $LOG_PATH
  [[ -n $2 ]] && execute "$2"
}

done=false

output "BoxBilling installation script @ $SCRIPT_VERSION"
output
output "https://github.com/AloneX079/BoxBilling"
output
output "This script is not associated with the official BoxBilling Project."

output

BOXBILLING_STABLE="$GITHUB_BASE_URL/master/install-stable.sh"

BOXBILLING_LATEST="$GITHUB_BASE_URL/master/install-latest.sh"

while [ "$done" == false ]; do
  options=(
    "[0] Install BoxBilling Stable Release"
    "[1] Install BoxBilling Latest Release"
  )
  
  actions=(
    "$BOXBILLING_STABLE"
    "$BOXBILLING_LATEST"
  )
  
  output "Select one of the following options!"
  
  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done
  
  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action
  
  [ -z "$action" ] && error "Input is required" && continue
  
  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done
  
