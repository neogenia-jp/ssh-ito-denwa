#!/bin/bash

# 設定ファイルで以下の情報が必要
#USER_NAME=user
#SSH_PASS=''

if [ -z "$LOGGER" ]; then
  if tty -s; then
    LOGGER=cat
  else
    LOGGER="logger -t $(basename -- $0)"
  fi
fi

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

echo "REV_PORT_FORWARD: $REV_PORT_FORWARD" | $LOGGER

# REV_PORT_FORWARD をカンマ区切り (例: 8080:192.168.1.15:80,8081:192.168.1.16:80) として複数対応
IFS=',' read -ra _parts <<< "$REV_PORT_FORWARD"
REV_FLAGS=()
for p in "${_parts[@]}"; do
  # 前後の空白を除去
  p="${p#"${p%%[![:space:]]*}"}"
  p="${p%"${p##*[![:space:]]}"}"
  if [ -n "$p" ]; then
    REV_FLAGS+=(-R "$p")
    echo "Adding reverse forward: $p" | $LOGGER
  fi
done

if [ "${#REV_FLAGS[@]}" -eq 0 ]; then
  echo '有効な REV_PORT_FORWARD が見つかりませんでした' | $LOGGER
  exit 1
fi

# SSH接続（複数の -R を展開して渡す）
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -N "${REV_FLAGS[@]}" ${USER_NAME}@$SSH_HOST -g | $LOGGER 2>&1
