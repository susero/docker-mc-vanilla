#日本人向けMinecraft(1.8.8)サーバー

Dockerがインストールされていれば、親サーバーの環境を汚染せずにMinecraftサーバーを運用可能なコンテナです。

日本人サーバー管理者向けに、以下の設定を行っています。

- サーバーのタイムゾーンが日本
- サーバーのローカルタイムが日本

これだけですが、ログに出力される時刻情報が日本標準時となるので、管理上の混乱を軽減してくれます。

#設定項目

コンテナ起動時に、以下の設定が可能です。

##基本設定項目

AGREE_TO_EULA (default: "false")
	最低限EULAを読んでこの項目をtrueにしてもらう必要があります。
	この項目をtrueに設定することで、あなたがMOJANGとの契約に同意したことになります。

JVM_MX (default: "2G")
	Minecraftサーバーを動作させる際に、JavaVMに利用を許可するメモリ量の最大値を指定します。デフォルトでは2GBとなっています。

JVM_MS (default: "1G")
	Minecraftサーバーを動作させる際に、JavaVMに占有を許可するメモリ量を指定します。デフォルトでは1GBとなっています。

JVM_BITS (default: "64")
	JavaVMにOSのビット数を指定します。

JVM_CORES (default: "2")
	JavaVMが使用可能なCPUコア数を指定します。
	これは、JavaVMのガーベージコレクションが行われる際に重要となります。
	少なめにとか多めに指定するものではなく、OS側のCPU数×コア数で算出される値を指定します。
	VPSなどの場合は選択したプランに書かれている数値をそのまま指定します。

SYSTEM_TIMEZONE (default: "Asia/Tokyo")
	システムのタイムゾーンを指定します。
	デフォルトで日本が設定されていることが、このコンテナの最大の特徴です。

#通常の起動

$ cd /home/user/mcs
$ docker run -ti --name minecraft-server -P -v $(pwd)/minecraft-server:/opt/minecraft -e AGREE_TO_EULA=true susero/minecraft-server-ja

初回の起動時に、minecraft_server-1.8.8.jarが公式のサイトからダウンロードされ、ワールドの生成が行われるため、実際にサーバーが起動するまでには少々時間がかかります。
二度目（データが残っている状態）からは、高速に起動すると思います。

## バインドするIPやポートを指定する

特殊ケースだと思いますが、Dockerコンテナを実行するシステムが複数のIPを持っている場合や、標準のポート番号(25565)を変更したい場合はDockerの-pオプションを使用してください。

IPアドレスが10.9.87.6、ポート番号が21212番を使いたい場合は

$ docker run -ti --name minecraft-server -p 10.9.87.6:21212:25565 -v $(pwd)/minecraft-server:/opt/minecraft -e AGREE_TO_EULA=true susero/minecraft-server-ja

ポート番号だけ21212番に変更したい場合は

$ docker run -ti --name minecraft-server -p 21212:25565 -v $(pwd)/minecraft-server:/opt/minecraft -e AGREE_TO_EULA=true susero/minecraft-server-ja

のように起動して下さい。

#ワールドのバックアップ

$ docker exec minecraft-server mcs:backup

/home/user/mcs/backupsディレクトリにバックアップが作成されます。
バックアップ処理中、Minecraftサーバーのサービスは停止状態となります。


#ワールドのホットバックアップ

$ docker exec minecraft-server mcs:hotbackup

Minecraftサーバーを停止せずにバックアップを行います。
単にサーバーを起動したままの状態でファイルをコピーしますので、破損したデータがバックアップされる可能性があります。
