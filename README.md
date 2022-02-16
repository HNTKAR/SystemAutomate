ネットワークブート用サーバの作成
- [DHCPサーバ](NetworkBootScript/DHCP.sh)
- [DHCPサーバ(DHCPサーバが既に存在する場合)](NetworkBootScript/DHCP_Proxy.sh)
- [HTTPサーバ](NetworkBootScript/nginx.sh)
- [TFTPサーバ(dnsmasqのtftpサーバを使いたくない場合)](NetworkBootScript/tftp.sh)

# 設定済みの値
|ユーザー名|パスワード|
|:-:|:-:|
|root|PASSWORD|
|owner|PASSWORD|

# インストール後の設定
```sh
sudo passwd owner
sudo hostnamectl set-hostname <HOSTNAME>
```