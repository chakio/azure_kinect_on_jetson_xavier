## Description
Jetson AGX Xavier等のARMアーキテクチャのPCにてAzure KinectをROS上で使用するためのセットアップ

## Requirement
* Jetson Tx2, Nano, Xavier, etc ...
* Azure Kinect

## Setup
* 参考サイト
    * https://proc-cpuinfo.fixstars.com/2019/06/nvidia-sdk-manager-on-docker/
    * https://qiita.com/Shunmo17/items/3bfd45ecb5c460bc4bc9
* 各設定方法はスクリプト化されており、scriptsフォルダに配置されています
* JetsonへのjetPackのインストール
    * Host PCを汚さないためのdockerfileを作ってくださった方がいらっしゃいます。
        * https://github.com/atinfinity/sdk_manager_docker
    * Jetson xavierの起動
        * Jetson の本体に，hdmi,キーボード,電源の接続 (初回起動時、Type cからの映像出力不可)
        * 電源を入れる（本体側面の3つのボタンのうち，一番左のボタンを押す）
        * 待っていると読み込みが始まる
        * 指示が出るので従って，セットアップを行う
    * hostPC用のdockerの実行
        * `$ ./launch_container.sh` でコンテナの起動
        * `$ sdkmanager` でjetpack sdk起動
        * 指示が出るので従って，セットアップを行う (Host PCとJetsonの接続時、Jetson側のポート注意)
* 冷却ファンの設定
    * `$ sudo nvpmodel -m 0 && sudo jetson_clocks` (再起動で初期化される)
    *  /etc/rc.localに追記し、起動時に冷却ファンが回るようにする
        * `$ sudo ./scripts/fun_setting.sh`
            ```sh:fun_setting.sh
            #!/bin/bash

            echo "# fun setting"
            sudo  nvpmodel  -m  0 && sudo jetson_clocks
            sudo echo -e "#!/bin/sh -e \n nvpmodel  -m  0 && jetson_clocks \n exit 0" > /etc/rc.local
            sudo chmod u+x /etc/rc.local
            ```

* 日本語入力
    * `$ sudo -s` (terminalの権限をsuperuserへ)
    * 日本語化
        * `$ sudo apt-get install -y aptitude && \sudo aptitude reinstall dbus`
        * `$ sudo apt autoremove && apt-get update && apt-get upgrade`
    * 日本語入力の設定
        * `$ sudo apt install  -y language-pack-ja-base  language-pack-ja`
		* `$ sudo apt install -y ibus-mozc`
    * mozcの設定
        * https://qiita.com/naoyukisugi/items/238f6e5060fb838827f6
    * 再起動

* arm版vscodeのインストール
    * `$ sudo -s` (terminalの権限をsuperuserへ)
    * Visual Studio Codeのインストール
        * `$ . <( wget -O - https://code.headmelted.com/installers/apt.sh ) `
    * 日本語入力の設定
        * `$ sudo apt install  -y language-pack-ja-base  language-pack-ja`
		* `$ sudo apt install -y ibus-mozc`
    * 起動
        * `$ code-oss`

* sudoなしでdockerを使う
    * `$ sudo gpasswd -a $(whoami) docker` docker グループにユーザーを追加
   	* `$ sudo chgrp docker /var/run/docker.sock` docker.sock にグループ書き込み権限を付与
   	* `$ sudo service docker restart` Docker daemon を再起動
  	* 再起動

* トラブルシューティング
    * aptget update時にNO_PUBKEY ED444FF07D8D0BF6みたいなエラーが出るとき
        * http://bigbuddha.hatenablog.jp/entry/apt-error-no-pubkey
        * `$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6` (エラーに応じて変更) 
	* E: Could not get lockみたいなエラーが出るとき
		* https://qiita.com/jizo/items/9496496a3156dd39d91a
        * `$ sudo rm /var/lib/apt/lists/lock`
        * `$ sudo rm /var/cache/apt/archives/lock`

## Docker
* 参考サイト
    * https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1093
    * https://github.com/valdivj/Azure-for-Kinect-Jetson-nano
* 概要
    * k4aviewrやrviz等の描画系が動作するようにするため、ベースイメージはnvidia:l4t-baseを選択
    * ubuntu が18.04となるためROSはmelodicをインストール
    * ROS化のためのパッケージはAzure_Kinect_ROS_Driverを使用
        * https://github.com/microsoft/Azure_Kinect_ROS_Driver
* Dockerの使用方法
    * イメージのビルド
        * `$ ./build.sh`
    * コンテナの起動 (kinectは接続してから)
        * `$ ./run.sh`
* Docker上でのkinectの使用方法
    * Azure Kinect SDKの確認
        * k4aviewer
            * `$ cd Azure-Kinect-Sensor-SDK/build/bin/k4aviewer`
    * ROS上での確認
        * Azure_Kinect_ROS_Driverの使用
            * `$ roslaunch Azure_Kinect_ROS_Driver driver.launch`
        * 動作確認は他のコンテナ等でrvizなどを実行

## Author
[chakio](https://github.com/chakio)