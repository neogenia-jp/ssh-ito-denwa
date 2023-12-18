#!/bin/bash

if [ -z "$LOGGER" ]; then
  if tty -s; then
    LOGGER=cat
  else
    LOGGER="logger -t $(basename -- $0)"
  fi
fi

if [ -z "$SSH_HOST" ]; then
  echo 'SSH_HOST を設定してください' | $LOGGER
  exit 1
fi

if [ -z "$REV_PORT_FORWARD" ]; then
  echo 'REV_PORT_FORWARD を設定してください' | $LOGGER
  exit 1
fi

# ダミーを設定
export DISPLAY=dummy:0

if [ -n "$SSH_PORT" ]; then
  SSH_PORT="-p $SSH_PORT"
fi

echo "SSH_HOST: $SSH_HOST" | $LOGGER
echo "SSH_PORT: $SSH_PORT" | $LOGGER
echo "SSH_PORT_FORWARD: $SSH_PORT_FORWARD" | $LOGGER

# SSH接続
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -N -R "$REV_PORT_FORWARD" $SSH_HOST -g | $LOGGER 2>&1

