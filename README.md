# ssh-ito-denwa

ssh-port-forward を永続的に稼働させるためのスクリプト

## Usage

```sh
# 設定
# - 接続先ホスト、転送先ポートなどの設定を行ってください。
# - 事前に ~/.ssh/config によって鍵認証の設定が出来ている前提です。
vi src/ssh-ito-denwa.sh

# 実行
bash src/ssh-ito-denwa.sh
```

### システム起動時に自動的に起動する設定

`crontab -e` で以下を設定してください。

```sh
@reboot nohup /path/to/ssh-ito-denwa.sh &
```

