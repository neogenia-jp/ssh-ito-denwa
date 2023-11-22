#!/bin/bash

# SSH逆ポートフォワードを永続的に行う

# 接続先情報
#USER_NAME=user
#SSH_PASS=''
SSH_HOST=
#SSH_PORT=

# ポートフォワードの設定
#   リモートポート:転送先ホスト:転送先ポート
REV_PORT_FORWARD=28086:localhost:8084

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

