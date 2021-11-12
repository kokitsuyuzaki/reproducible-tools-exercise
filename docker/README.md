# Docker

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
     - **イメージ**と**コンテナ**の違い
       - イメージ: コンテナを作るもととなるもの、実体としてはファイル
       - コンテナ: 走らせているイメージのインスタンス、実体としてはプロセス
       - イメージのことをコンテナイメージとも言う
       - 文脈によっては、区別できないこともある
     - Dockerは常駐プログラム（デーモン）、まずdocker.appを立ち上げて、それに対して処理を要求する構図

## Dockerを使う
   - イメージをDockerHubから取得
     - コマンドツール（例: salmon）: https://combine-lab.github.io/salmon/getting_started/#obtaining-salmon

      ```bash
      docker pull combinelab/salmon:latest
      ```

     - 対話解析ツール（例: R）
       - Docker containers for Bioconductor: https://www.bioconductor.org/help/docker/

      ```bash
      docker pull bioconductor/bioconductor_docker:RELEASE_3_14
      ```

       - rocker/rstudio: https://hub.docker.com/r/rocker/rstudio

      ```bash
      docker pull rocker/rstudio:4.1.2
      ```

   - イメージ一覧

      ```bash
      docker images
      ```

   - コンテナ一覧

      ```bash
      docker ps
      docker run -e PASSWORD=<choose_a_password_for_rstudio> -p 8787:8787 rocker/rstudio:4.1.2
      docker ps # 別のターミナル画面で
      ```

   - イメージからコンテナを立ち上げ実行

      - Bioconductorを使うなら、Bioconductorが配布しているイメージがおすすめ

      ```bash
      docker run -it --rm -v $(pwd):/work bioconductor/bioconductor_docker:RELEASE_3_14 bash
      ```

      - Anacondaに登録されるRパッケージ（CRAN/Bioconductor）は、BioContainersがDockerイメージ化してくれている
      - cf. https://bioconda.github.io/recipes/bioconductor-sctensor/README.html

      ```bash
      docker run -it --rm -v $(pwd):/work quay.io/biocontainers/bioconductor-sctensor:2.4.0--r41hdfd78af_0 bash
      ```

   - いらないものを削除する系

      ```bash
      docker rm $(docker ps -q -a) # コンテナを停止
      docker rmi $(docker images -q) -f # イメージを削除
      # いらないものを適宜削除
      docker image prune -f
      docker container prune -f
      docker volume prune -f
      docker network prune -f
      docker builder prune -f
      # 現在の状況確認
      docker system df
      ```

## Dockerイメージを自作する
   - **Dockerfile**の作り方
     - おすすめベースイメージ
       - Rocker系: https://hub.docker.com/search?q=rocker&type=image
       - Bioconductor: https://hub.docker.com/r/bioconductor/bioconductor_docker
       - BioContainers（ただし該当パッケージが1個入っているだけ）: https://bioconda.github.io/recipes/bioconductor-sctensor/README.html
       - Miniconda3: Snakemakeが推奨している
         - cf. https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#ad-hoc-combination-of-conda-package-management-with-containers
     - 各種タグ（FROM, ENV, ADD, RUN, ENTRYPOINT）

   - イメージの作りこみ方
     - まずベースイメージに入って動作確認
     - 環境ができあがったら、Dockerfileがあるディレクトリで`docker build -t アカウント名/イメージ名:タグ名`

  - DockerHubにプッシュ
    - タグ名の付け方
      - latestタグは使うな
      - 日付がおすすめ`date '+%Y%m%d'`

      ```bash
      # DockerHubに最新版をプッシュ
      docker login -u koki
      img=`docker images | grep koki/rstudio_mesh | awk '{print $3}'`
      docker tag $img koki/rstudio_mesh:$(date '+%Y%m%d')
      docker push koki/rstudio_mesh:$(date '+%Y%m%d')
      ```

## Snakemakeとの連携
  - Singularityでイメージファイルを落としてきている（HTC環境）
  - 毎回 rm -rf .snakemake/singularityをすること

