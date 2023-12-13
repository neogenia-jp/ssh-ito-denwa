#!/bin/bash

if [ -z "$SSH_HOST" ]; then
  echo 'SSH_HOST を設定してください'
  exit 1
fi

if [ -z "$REV_PORT_FORWARD" ]; then
  echo 'REV_PORT_FORWARD を設定してください'
  exit 1
fi

# ダミーを設定
export DISPLAY=dummy:0

if [ -n "$SSH_PORT" ]; then
  SSH_PORT="-p $SSH_PORT"
fi

# SSH接続
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -N -R "$REV_PORT_FORWARD" $SSH_HOST -g

