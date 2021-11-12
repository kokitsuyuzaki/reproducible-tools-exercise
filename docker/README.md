# Docker
![Docker](https://d1q6f0aelx0por.cloudfront.net/product-logos/library-docker-logo.png, "Docker")

## 準備
   - docker for Macをインストール: https://www.docker.com
   - docker.appを起動
   - ターミナルで`docker -v`が動くか確認
## Dockerとは
   - 仮想化技術の一つ
   - 自分のツール + 動作する環境（OS、ミドルフェア）ごとユーザーに提供できる
   - `docker`コマンドが動く環境であれば、原理上どこでも動く
   - OSの最低限の機能だけを格納した軽量な環境（**コンテナ**）の中に、自分のデータを格納配布する
   - **DockerHub**: Dockerコンテナを集めるレポジトリ https://hub.docker.com
   - 他の仮想化技術
     - VirtualBox, VMwareFusion, Cygwin: 重すぎるので配布に向かない、配布を目的としていない
     - Singularity: 類似したコンテナ技術
     - Singularity:
   - 注意点
     - イメージとコンテナの違い
     ![Image](https://hacknote.jp/wp-content/uploads/2020/03/docker_image_container.png, "Image")
       - イメージ: コンテナを作るもととなるもの、実体としてはファイル
       - コンテナ: 走らせているイメージのインスタンス、実体としてはプロセス
       - イメージのことをコンテナイメージとも言う
       - 文脈によっては、区別できないこともある
     - Dockerは常駐プログラム（デーモン）、まずdocker.appを立ち上げて、それに対して処理を要求する構図

## Dockerを使う
   - プル: pull
   - 実行: run
   - イメージ一覧: images
   - コンテナ一覧: containers
   - いらないものを削除する系:
    # たまにこれでエラーになる
    rm -rf ~/.docker/config.json

    # いらないものを適宜削除
    docker rm $(docker ps -q -a)
    docker rmi $(docker images -q) -f
    docker image prune -f
    docker container prune -f
    docker volume prune -f
    docker network prune -f
    docker builder prune -f
    docker system df

## Dockerイメージを作る
   - Dockerfileの作り方
     - ADDタグで.Rをイメージ内部に格納
   - イメージの作り方
     - まずベースイメージに入って動作確認
    # docker run -it --rm koki/rstudio_mesh:$(date '+%Y%m%d') bash
     - docker build -t アカウント名/イメージ名 .

  - プッシュ
  - latestタグは使うな
  # DockerHubに最新版をプッシュ
  docker login -u koki
  img=`docker images | grep koki/rstudio_mesh | awk '{print $3}'`
  docker tag $img koki/rstudio_mesh:$(date '+%Y%m%d')
  docker push koki/rstudio_mesh:$(date '+%Y%m%d')

## Snakemakeとの連携
  - Singularityでイメージファイルを落としてきている（HTC環境）
  - 毎回 rm -rf .snakemake/singularityをすること

