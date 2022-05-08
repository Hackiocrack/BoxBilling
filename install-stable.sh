#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives)"
  exit 1
fi

# Define Variables
url=""

# MySql Credentials
type="mysql"
host="127.0.0.1"
name="boxbilling"
user=""
password=""

# Initial Admin Account
user_email=""
user_username=""
user_firstname=""
user_lastname=""
user_password=""

# Assume SSL, will fetch different config if true
SSL_AVAILABLE=false
ASSUME_SSL=false
CONFIGURE_LETSENCRYPT=false

# Download URLs
BOXBILLING_STABLE_URL=""
