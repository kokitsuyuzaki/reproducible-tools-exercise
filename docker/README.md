# Docker
## 目次
- [準備](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#準備)
- [Dockerとは](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#dockerとは)
- [DockerHubとは](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#dockerhubとは)
- [他人が作ったDockerイメージを使う](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#他人が作ったdockerイメージを使う)
- [Dockerイメージを自作する（Dockerfile）](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#dockerイメージを自作するdockerfile)
- [Snakemakeとの連携](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/docker#snakemakeとの連携)

## 準備
- [Docker for Mac](https://www.docker.com)をインストール
- docker.appを起動
- ターミナルで`docker -v`が動くか確認
- （オプショナル）重い計算をする場合や、データが大きくなることが予想される場合、割り当てるディスク容量・メモリ使用量を変更
    - cf. [ikra](https://github.com/yyoshiaki/ikra#for-mac-users)

## Dockerとは
- **仮想化技術の一つ**
  - 自分のツール + 動作する環境（OS、ミドルフェア、共有ライブラリ...etc）ごとユーザーに提供できる
  - 異なる環境でツールのインストールに失敗することが無い
  - OSの最低限の機能だけを格納した軽量な環境（**コンテナ**）の中に、自分のデータやコードを格納して配布する
  - ∴`docker`コマンドが動く環境であれば、原理上どこでも動く
- **関連技術**
    - デスクトップ型: e.g., VirtualBox, VMwareFusion
        - さらに、これらの設定や立ち上げにvagrantというコマンドも使われる
        - 重すぎるので配布に向かない、配布を目的としていない
        - 環境構築に時間がかかりすぎ、使い捨てに向いていない
    - コンテナエンジン
        - DockerHub/Quay.ioにあるイメージを取得して、実行するコマンド
        - uDocker, Podman, Shifter, CharileCloud...など、複数存在（主に管理者権限のポリシーの違いによる）
        - Singularity
            - High-throughput Computing（HTC）環境に適したDocker（後述）
            - Snakemakeと連携（後述）
- **その他注意点**
    - イメージとコンテナの違い
        - **イメージ**: コンテナを作るもととなるもの、実体としてはファイル
        - **コンテナ**: 走らせているイメージのインスタンス、実体としてはプロセス
        - イメージのことを"コンテナイメージ"と言う場合もある
    - Dockerは常駐プログラム（デーモン）
        - まずdocker.appを立ち上げて、それに対して処理を要求する構図

## DockerHubとは
- Dockerイメージを集めたレポジトリ
    - **DockerHub**
        - Dockerコンテナを集めるレポジトリ: https://hub.docker.com
        - Dockerのアカウントでログインできる
        - 無料: 時間ごとのプル数に制限あり https://www.docker.com/pricing
    - **Quay.io**
        - RED HATが提供するレポジトリ: https://quay.io
        - BiocondaはQuay派
        - 有料: https://quay.io/plans/

## 他人が作ったDockerイメージを使う
- **イメージをDockerHubから取得**
    - コマンドツール: [salmon](https://combine-lab.github.io/salmon/getting_started/#obtaining-salmon)

      ```bash
      docker pull combinelab/salmon:latest
      ```

    - コマンド/対話解析ツール（例: R）
        - [Docker containers for Bioconductor](https://www.bioconductor.org/help/docker/)

          ```bash
          docker pull bioconductor/bioconductor_docker:RELEASE_3_14
          ```

        - [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio)

          ```bash
          docker pull rocker/rstudio:4.1.2
          ```

- **イメージ一覧**

    ```bash
    docker images
    ```

- **イメージからコンテナを立ち上げ実行**
    - Bioconductorを使うなら、Bioconductorが配布しているイメージがおすすめ
    - 各種オプション
      - `-i` or `--interactive`: 標準入力の受け取り許可
      - `-t` or `--tty`: 端末（e.g. シェル）で起動
      - `--rm`: クリーンアップ（コンテナ終了時に、ファイルシステムを削除）
      - `-v`: マウントディレクトリ（コンテナ内外が繋がっている場所）

          ```bash
          docker run -it --rm -v $(pwd):/work bioconductor/bioconductor_docker:RELEASE_3_14 bash
          ```

    - Anacondaに登録されているRパッケージ（CRAN/Bioconductor）は、BioContainersがDockerイメージ化してくれている
        - ただし、そのパッケージしか入っていない（cf. [bioconductor-sctensor](https://bioconda.github.io/recipes/bioconductor-sctensor/README.html)）

          ```bash
          docker run -it --rm -v $(pwd):/work quay.io/biocontainers/bioconductor-sctensor:2.4.0--r41hdfd78af_0 bash
          ```

- **コンテナ一覧**

```bash
docker ps
docker run -e PASSWORD=<choose_a_password_for_rstudio> -p 8787:8787 rocker/rstudio:4.1.2
docker ps # 別のターミナル画面で確認
```

- **いらないものを削除する系**

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

- **履歴系**

  ```bash
  docker history [イメージID]
  docker logs [コンテナID]
  ```

## Dockerイメージを自作する（Dockerfile）
- **Dockerfileの作り方**
  - 各種タグ
    - **FROM**: ベースイメージの指定
    - **ENV**: 環境変数の指定
    - **ADD**: ローカルにあるファイルの取り込み（本当はあまり良くない、次回Git回で説明）
    - **RUN**: シェルを実行
    - コンテナ起動時の設定
      - CMD/ENTRYPOINT: コンテナ起動時に実行するコマンド
  - ベースイメージはどれを使うか
      - Alpine系は簡素すぎて、いろいろ足りないので、データサイエンスには向かない
      - おすすめベースイメージ
          - できるだけ必要なツールが事前にインストールされている環境を選ぶ
          - [Rocker系](https://hub.docker.com/search?q=rocker&type=image)
          - [Bioconductor](https://hub.docker.com/r/bioconductor/bioconductor_docker)
          - [Bioconda/BioContainers](https://bioconda.github.io/recipes/bioconductor-sctensor/README.html)（ただし該当パッケージが1個入っているだけ）
          - [Miniconda3](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#ad-hoc-combination-of-conda-package-management-with-containers): Snakemakeが推奨
  - イメージの作りこみ方
      - コンテナ内部に取り込まないファイルは **.dockerignore** に記述（e.g. update_dockerfile.sh）
          - 何も考えるデータ解析しているディレクトリで`docker build`してはいけない（データもコードも何もかもコンテナ内部に取り込もうとする）
      - Dockerfile自体はGitHubで一箇所に集めておくのがおすすめ
          - cf. https://github.com/kokitsuyuzaki/Dockerfiles
      - いきなりDockerfileを実行しない
      - まずベースイメージに入って動作確認
      - 環境ができあがったら、その手順をDockerfileに記述
      - Dockerfileがあるディレクトリで以下を実行
  - 実例: 次元圧縮手法の公開（cf. Dockerfile）

    ```bash
    docker build -t koki/reductdims .
    ```

- **動作確認**
    - `docker run`の後に、コンテナ内部で実行するコマンドを続けて書く
    - 実例: 次元圧縮手法の公開

    ```bash
    R -e 'input <- matrix(runif(50*100), nrow=50, ncol=100); write.csv(input, "input.csv")'
    docker run -it --rm -v $(pwd):/work \
    koki/reductdims Rscript cmd_reductDims.R \
    /work/input.csv \
    10 \
    2 \
    svd \
    TRUE \
    /work/output.RData \
    /work/output.png
    ```
    - `run`は`pull`も兼ねているから、ユーザーには`run`のコマンドを実行してもらうだけ

- **DockerHubにプッシュ**
  - タグ名の付け方
    - 大文字のアルファベットは使えない（e.g. × koki/MyTool → ○ koki/mytool）
    - latestタグは使わない
        - latestタグは、最新のイメージに自動的に付けられる特殊なタグ名
        - ローカルのイメージにlatestタグをつけてしまうと、古いイメージが上書きされてしまう、後でデバッグしづらい
    - もとのソースコードがGitHub上にある場合、gitのコミットID、リリース名、タグ名などをdockerのタグ名にする
    - cf. https://speakerdeck.com/inutano/describe-data-analysis-workflow-with-workflow-languages
    - 良いタグ名が思いつかなかったら、単に日付でも良い気がする

      ```bash
      docker login -u koki
      img=`docker images | grep koki/reductdims | awk '{print $3}'`
      docker tag $img koki/reductdims:$(date '+%Y%m%d')
      docker push koki/reductdims:$(date '+%Y%m%d')
      ```

- **Dockerfileの書き方についてのTips**
  - 書き方次第でイメージファイルサイズに違いが出る
  - なるべくRUNタグは一つですませる（&&や\を利用してワンライナーで書く）
  - 詳しくは「Dockerfile ベストプラクティス」で検索（マルチステージビルドなど）

## Snakemakeとの連携
- **Singularity**
    - SnakemakeはSingularityで、DockerHub・SingularityHub上にあるイメージを活用
    - elwood上の運用は、全員がdockerの管理者権限を持っている状態でかなり特殊
        - 自由にイメージを作成、プッシュ、プルができる
        - 他のメンバーのイメージ・コンテナが見える、削除できる
    - 通常は、共同計算機上ではdockerコマンドは使えない（e.g. 遺伝研スパコン）
    - 管理者権限がいらない（root lessな）dockerが欲しい → Singularity
    - イメージは.simgという拡張子のファイルとして、手元に落とされる
    - `singularity`コマンドが使える環境であれば、イメージファイルを実行できる

      ```bash
      singularity pull salmon.simg docker://combinelab/salmon:latest
      singularity shell salmon.simg # Singularityイメージファイルに入る
      singularity exec salmon.simg salmon -v # salmonを実行
      ```

    - cf. [遺伝研スパコンの資料](https://sc.ddbj.nig.ac.jp/software/Singularity)
    - DockerHub側が更新されても、それを認識してpullし直すことはないのに注意
    - 毎回`rm -rf .snakemake/singularity`をすること
    - 逆に管理者権限が無いせいで、コンテナ内部でできない作業が出る場合もあるので、環境作りこみはdockerのほうがやりやすい気がする（私見）
- **Snakefileの書き方**
    - condaは再現性がとれない場合があるのでSingualrity推奨: https://gist.github.com/kokitsuyuzaki/c24656f277a8fba8242d698349514421
    - 使い方は、Anacondaの時とほとんど同じ: https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#running-jobs-in-containers
        1. Snakefile内で`container:`タグを使う（⇄`conda:`）
        2. あとはsnakemakeコマンドに`--use-singularity`オプションを付けるだけ（⇄`--use-conda:`）
- **コンテナ化の粒度**
    - Dockerは「1コンテナ1プロセス」が基本
      - docker run [自作コマンド]で終わらせられる規模感を想定
      - なるべく軽量に作る、全部入りコンテナは避ける
      - 作るのも管理するのも大変だから
    - 一方、Rパッケージは複数のパッケージと組み合わせていることを想定（Dockerの思想と合わない部分）
    - Rパッケージは、1つのパッケージにつき、複数の依存パッケージを引き連れてしまう
    - コンテナ内部にインストールするパッケージ数が増えるに従い、イメージサイズが肥大化
    - 折衷案として、せいぜい10パッケージ分くらいのコンテナを複数作成
    - 前処理用、解析1用、解析2用、可視化用、レポート用...etcくらいの、互いに独立なタスクで分割