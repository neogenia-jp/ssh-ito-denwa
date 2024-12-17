# ssh-ito-denwa

ssh-port-forward を永続的に稼働させるためのスクリプト

## Usage

### インストール

debパッケージのインストール
（現在、UbuntuなどDebian系 ディストリビューションのみサポートしています）

```sh
# バージョン番号の部分は、適宜読み替えてください
sudo dpkg -i ./ssh-ito-denwa_x.x.x.deb
```

アンインストール

```sh
sudo dpkg -r ssh-ito-denwa
```

### 設定

`/etc/ssh-ito-denwa.conf` に設定ファイルがあります。
- 接続先ホスト、転送先ポートなどの設定を行ってください。
- SSH接続設定については、この設定ファイルで行いません。
  事前に root ユーザで `~/.ssh/config` によって鍵認証の設定を完了させておく必要があります。

```sh
# 設定ファイルを編集
sudo vi /etc/ssh-ito-denwa.conf
```

### サービスの制御

`systemd` サービスとしてインストールされますので、 `systemctl` コマンドで操作してください。

```sh
# 起動
systemctl start ssh-ito-denwa

# 起動状態確認
systemctl status ssh-ito-denwa

# 停止
systemctl stop ssh-ito-denwa
```

エラー発生時は、syslogにログが出力されています。
適宜参照してください。

```sh
# ログを確認
less /var/log/syslog
```

OS起動時にサービスを自動起動させるには、以下のようにします。
（systemdの一般的な操作方法です）

```sh
# OS起動時のサービス自動起動を有効化
systemctl enable ssh-ito-denwa

# OS起動時のサービス自動起動を無効化
systemctl disable ssh-ito-denwa
```

### 接続先での設定

リモートポートに外部から接続する場合（ssh接続先ホストのさらに外側のホストから、フォワードさせるポートへの接続を許可したい場合）、
`/etc/ssh/sshd_config` にて、以下の設定を有効化しておく必要があります。

```
GatewayPorts yes
```

## パッケージビルド

```sh
cd package
sudo ./make_deb.sh

# 成果物の確認。ssh-ito-denwa_x.x.x.deb ファイルが出来上がります。
ls -l
```

