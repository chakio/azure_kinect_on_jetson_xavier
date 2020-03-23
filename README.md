## Description
ubuntuをベースにROSとGUI表示の環境を構築するdockerfileです。

## Requirement
* docker
* NVIDIAのGPU

## Usage
* nvidia-docker2のインストール 
    * ホストのPCにインストールされているnvidiaドライバのバージョンの更新  
        (400番代以上が理想 geforce 1060や1660の場合はnvidia-418)
        * 古いドライバの削除
            ```sh
            $ sudo apt-get --purge remove nvidia-*
            $ sudo apt-get --purge remove cuda-*
        * 新しいドライバのインストール
            ```sh
            $ sudo add-apt-repository ppa:graphics-drivers/ppa
            $ sudo apt-get update
            $ sudo apt-get install nvidia-418
            $ sudo reboot
        * 確認
            ```sh 
            $ nvidia-smi
    * nvidia-docker2のインストール
        ```sh 
        $ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \sudo apt-key add -
        $ curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
        $ sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        $ sudo apt-get update
        $ sudo apt-get install -y nvidia-docker2
        $ sudo pkill -SIGHUP dockerd
    * 確認
        ```sh 
        $ docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
* ホストマシンにROS用のパッケージのセッティング
    * catkin_ws/srcをホストマシンに作成
    * catkin_ws/srcにROS用のパッケージをコピー
    * dockerfileの72行目をコメントアウト(まだ/catkin_ws/devel/setup.bashが存在しないため)
    * 一旦 docker run
        * ./build.shでdocker build
        * ./run.shでdocker run
    * catkin_wsのcatkin_init_workspace
    * catkin_make(まだ/catkin_ws/devel/setup.bashが作成される)
* ROS用のパッケージのセッティング後
    * dockerfileの72行目のコメントアウトを解除
    * ./build.shでdocker build
    * ./run.shでdocker run
    * 使用状況に応じて、dockerfileの後半部分のrosの設定を変更

## Author
[chakio](https://github.com/chakio)