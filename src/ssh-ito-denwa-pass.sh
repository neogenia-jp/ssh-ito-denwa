#!/bin/bash

# 設定ファイルで以下の情報が必要
#USER_NAME=user
#SSH_PASS=''

if [ -z "$SSH_HOST" ]; then
  echo 'SSH_HOST を設定してください'
  exit 1
fi

if [ -z "$REV_PORT_FORWARD" ]; then
  echo 'REV_PORT_FORWARD を設定してください'
  exit 1
fi

if [ -z "$USER_NAME" ]; then
  echo 'USER_NAME を設定してください'
  exit 1
fi

if [ -z "$SSH_PASS" ]; then
  echo 'SSH_PASSを設定してください'
  exit 1
fi


# 後述のSSH_ASKPASSで設定したプログラム(本ファイル自身)が返す内容
# 参考: https://qiita.com/wadahiro/items/977e4f820b4451a2e5e0
if [ -n "$PASSWORD" ]; then
  cat <<< "$PASSWORD"
  exit 0
fi

# SSH_ASKPASSで呼ばれるシェルにパスワードを渡すために変数を設定
export PASSWORD=$SSH_PASS

# SSH_ASKPASSに本ファイルを設定
export SSH_ASKPASS=$0
# ダミーを設定
export DISPLAY=dummy:0

if [ -n "$SSH_PORT" ]; then
  SSH_PORT="-p $SSH_PORT"
fi

# SSH接続 & リモートコマンド実行
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -N -R "$REV_PORT_FORWARD" ${USER_NAME}@$SSH_HOST -g

