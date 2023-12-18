#!/bin/bash
# ssh-ito-denwa エントリポイント

CONF_FILE=${CONF_FILE:-/etc/ssh-ito-denwa.conf}

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
cd $SCRIPT_DIR

if [ -e $CONF_FILE ]; then
  source $CONF_FILE
elif [ -e ./config ]; then
  source ./config
fi

if [ -n "$SSH_PASS" ]; then
  exec ./ssh-ito-denwa-pass.sh
else
  exec ./ssh-ito-denwa.sh
fi

