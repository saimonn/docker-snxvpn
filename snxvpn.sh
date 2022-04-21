#!/bin/bash

function fail() {
  echo "FATAL: $@"
  exit 42
}

function debug() {
  echo "[${SCRIPT_NAME}] DEBUG: $@"
}

# Follow symlink to the script path:
f=$0
while g="$(readlink $f)" ;do
  export f="$g"
done
SCRIPT_DIR="$(dirname $f)"
SCRIPT_NAME="$(basename $f)"


# Find first existing config_file 
config_file_list="
  ${SCRIPT_DIR}/snxvpn.cfg
  ~/.config/docker-snxvpn.cfg
"
for CONFIG_FILE in $config_file_list 
do
  if [ -r "$CONFIG_FILE" ];then
    export CONFIG_FILE
    break
  fi
done

if [ -f "$CONFIG_FILE" ] ;then
  debug "Using config file $CONFIG_FILE"
  source "$CONFIG_FILE"
fi

SCRIPT_DIR=${SCRIPT_DIR:-$HOME/dev/docker-snxvpn}

[ -z $SNX_USER     ] && fail '$SNX_USER is not set'
[ -z $SNX_PASSWORD ] && fail '$SNX_PASSWORD is not set. Sometimes it is made of ${TOKEN}${PIN}'
[ -z $SNX_HOST     ] && fail '$SNX_HOST is not set'

usage () {
 echo "Usage: $0 [--build] [--help]"
 echo "  [Build and] Launch the snxvpn Docker image with your favorite options."
}

build () {
 pushd "$SCRIPT_DIR"
 docker build --no-cache -t snxvpn .
 popd
}

case $1 in
  -h|--help)
    usage; exit;;
  -b|--build)
    build;;
esac

docker images |grep -qw '^snxvpn' || build

if (docker ps --filter  name=snxvpn  |grep -w snxvpn ) ;then
  echo '***************************************************'
  echo '* an snxvpn docker container is already running. *'
  echo '***************************************************'
  echo
  read -p "> Continue and launch docker run..snxvpn anyway [y/N]" ANS
  case $ANS in
    y*|Y*)
      echo "YOLO"
      ;;
    *)
      echo "bye"
      exit 1
  esac
fi

docker run --rm --net host --name snxvpn   \
        -e SNX_HOST=$SNX_HOST              \
        -e SNX_USER=$SNX_USER              \
        -e SNX_PASSWORD=$SNX_PASSWORD      \
        snxvpn "$@"
