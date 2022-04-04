ネットワークブート用サーバの作成
- [DHCPサーバ](PXEboot/DHCP.sh)
- [DHCPサーバ(DHCPサーバが既に存在する場合)](PXEboot/DHCP_Proxy.sh)
- [HTTPサーバ](PXEboot/HTTP.sh)
- [TFTPサーバ(dnsmasqのtftpサーバを使いたくない場合)](PXEboot/TFTP.sh)

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