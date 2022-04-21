#!/bin/sh -x

# Default values:
SNX_REALM="${SNX_REALM:-ssl_vpn_Radius}"
SNX_FILE="${SNX_FILE:-Login/Login}"
SNX_EXTENDER="${SNX_EXTENDER:-SNX/extender}"

check_empty() {
  varname="$1"
  eval "var=\$$varname"
  if [ -z "$var" ];then
    echo "ERR: variable \`$varname' is not set. EXIT 2"
    exit 2
  fi
}

if [ `id -u` -ne 0 ] ;then
  echo "ERR: This container should be run as root."
  exit 3
fi

check_empty SNX_HOST
check_empty SNX_REALM
check_empty SNX_FILE
check_empty SNX_EXTENDER
check_empty SNX_USER
check_empty SNX_PASSWORD

exec /usr/local/bin/snxconnect --host "$SNX_HOST" --realm "$SNX_REALM" --file "$SNX_FILE" --extender "$SNX_EXTENDER" --user "$SNX_USER" -P "$SNX_PASSWORD"
