#!/bin/bash

# SSH逆ポートフォワードを永続的に行う

# 接続先情報
# あらかじめSSH鍵認証の設定を ~/.ssh/config で行い、sshコマンドで接続可能な状態にしておいてください
SSH_HOST=
#SSH_PORT=

# ポートフォワードの設定
#   リモートポート:転送先ホスト:転送先ポート
REV_PORT_FORWARD=28086:localhost:8084

# ダミーを設定
export DISPLAY=dummy:0

if [ -n "$SSH_PORT" ]; then
  SSH_PORT="-p $SSH_PORT"
fi

# SSH接続
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -N -R "$REV_PORT_FORWARD" $SSH_HOST -g

