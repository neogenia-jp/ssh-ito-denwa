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
ssh $SSH_PORT -C -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o TCPKeepAlive=no -N "${REV_FLAGS[@]}" $SSH_HOST -g | $LOGGER 2>&1
