# Git × Docker
## 目次
- [準備](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#準備)
- [`git`コマンドとは](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#`git`コマンドとは)
- [GitHubとは](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#GitHubとは)
- [`gh`コマンドとは](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#`gh`コマンドとは)
- [`git`コマンド集](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#`git`コマンド集)
- [GitHub上での操作](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#GitHub上での操作)
- [`gh`コマンド集](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#`gh`コマンド集)
- [Git⇄Docker連携によるツール公開](https://github.com/kokitsuyuzaki/reproducible-tools-exercise/tree/main/git_docker#gitdocker連携によるツール公開)

## 準備
- **`git`コマンド**
	- 大抵どこにでもあるが、MaxではXcodeのコマンドライン・デペロッパーツールが必要かも
	- ターミナルで`git --version`が動くか確認
- **GitHubアカウント**
	- 無ければ作成: https://github.co.jp
	- SSH認証の設定も必要
	- 最近、個人アクセストークン（PAT）の設定も必要
		- 頻繁に変更することが推奨されているパスワードみたいなもの
- **`gh`コマンド**
	- 無ければ、`brew install gh`
- **Dockerコマンド/DockerHub**
	- 前回の内容を確認

## `git`コマンドとは
- ファイルの変更履歴を記録・追跡する、バージョン管理ツール（VCS）
- **ローカルレポジトリ**: ローカルマシン上に作られたレポジトリ
- **リモートレポジトリ**: リモートサーバ上に作られたレポジトリ（GitHubなど）
- 関連技術
    - 集中型VCS: CVS, Subversion
        - 中央レポジトリ（リモートレポジトリ）だけが、レポジトリの管理を行う
        - コミットやチェックアウト（後述）といった操作は全て中央レポジトリに対して行われる
        - 対してGitやMercurialは分散型VCS
	        - ローカルでもリモートでも、レポジトリを管理できる
	        - ローカルだけで管理しても良いし、適宜ローカル⇄リモート連携できる
- GUIツールである程度対話的に操作可能: [Git GUI](https://git-scm.com/downloads/guis), [Sourcetree](https://www.atlassian.com/ja/software/sourcetree), [GitKraken](https://www.gitkraken.com)
    - ただし、今回はこれらは一切使わない

## GitHubとは
- Gitレポジトリを集めたレポジトリ
- 関連レポジトリ: GitLab, SourceForege, Bitbucket, BitBucket
- ローカルレポジトリとの連携の仕方
	- リモートが先の場合（一番スムーズ）
		- まずGitHub上で先にリモートレポジトリを作り、それをローカルにそれをコピー
  （`git clone`）
	- ローカルが先の場合
		- 旧式: ローカルと同名のリモートレポジトリをGitHub上で作成し、`git remote add origin`（cf. [Bioc2020でのトラブルの様子](https://youtu.be/fq3kx6FZ6lY?list=PLdl4u5ZRDMQSENJBo6k_wcA27gtydm-bz&t=776)）
		- 新方式: 作ったディレクトリで`git init`した後、`gh repo create`（後述）

## `gh`コマンドとは
- GitHub公式のCLI
- GitHubレポジトリに対する操作に特化したコマンド
- 関連ツール: `hub`（非公式CLI）

## `git`コマンド集
### 初期設定

```bash
git config --global user.name [自分のGitHubアカウント名]
git config --global user.email [登録したメールアドレス]
```

### Pull関係
- リモートレポジトリをローカルに反映

```bash
# ローカルにリモートレポジトリをコピー
git clone https://github.com/kokitsuyuzaki/test.git
# 他にも開発者と同時並行で作業している時に
# 自分のリモートレポジトリを最新の状態にする系
# origin/main（リモート追跡用ブランチ）に反映
cd test
git fetch
git pull origin main # = git fetch origin && git merge origin/main
# または省略可能
git pull
```

- fetchとpullの違い: https://qiita.com/wann/items/688bc17460a457104d7d

### git管理の対象外ファイルを設定

```bash
echo ".DS_Store" > .gitignore
echo "._" >> .gitignore
```

### Push関係
- ローカルレポジトリをリモートに反映
- `add`は、ステージング領域に登録
- `commit`は、ステージング領域からGitディレクトリ（.git）に登録

```bash
# 更新対象を指定、ステージング領域に変更履歴を登録
git add --all
git add .gitignore
git rm [ファイル名] # ステージング領域から除外
git commit -m [メッセージ] # .gitディレクトリに変更履歴を登録
# 変更履歴をリモートレポジトリに転送
# origin: ローカルレポジトリの別名
# main: ブランチ名（後述）
git push origin main
# originもmainも省略可能
git push
```

### 現状把握関係

```bash
git status # 現在どういう状況か（ファイルの変更、コミットしたか...etc）
git log # これまでのログを出力
git log --graph # グラフ表示（ブランチが多い場合見やすい）
git log --oneline # 一行表示
git show [コミットハッシュ] # あるコミットの内容を確認
git diff # 前回のコミットとの差分
git diff [コミットハッシュ] # あるコミットとの差分
git diff [コミットハッシュ1] [コミットハッシュ2] # ２つのコミット間の差分
```

### 変更関係
- レポジトリを過去の特定の状態に戻すことが可能

```bash
git log # どの状態に戻るか確認
git reset [コミットID] # そのコミット位置まで戻る
git revert [コミットID] # そのコミットを取り消す（そのコミットと逆の内容のコミットを新規に行う）
```

### Branch関係
- 最初にいるブランチはmain（旧[master](https://www.publickey1.jp/blog/20/githubmainmastermain.html)ブランチ）
- mainとは別のブランチを切って、そこでバージョン管理して、最後mainにマージするという開発の仕方もある
- 最初から特定の名前が付いているブランチ・レポジトリ名
  - **main**: 最初にいるブランチ
  - **origin/main**: リモート追跡用ブランチ（ローカルにだけある）
  - **gh-pages**: GitHub Pagesの公開用ブランチ
  - **origin**: リモートレポジトリのこと
  - **upstream**: フォークして作ったレポジトリにおけるフォーク元レポジトリ
  - ...etc
- （一人で開発している時にはあまり使わない気もする）
- 例えば、複数人で同時に同じソフトウェア開発を行っている場合
- リリース用（main）、新規機能追加（feature）、デバッグ（debug）など、別のタスクが同時並行で走っている時、ブランチで分けておくと、整理しやすい
- [ブランチモデル](https://gist.github.com/manabuyasuda/f449b313970c7a51b655#ブランチモデル)（どのようにブランチを運用していくか）として、Git Flow、GitHub Flowなど
- または、一人で開発する場合でも、全作業を毎回ブランチを切って行い、一区切りついたら、mainにマージする（mainを汚さない方針）というやり方も

```bash
# ブランチの一覧
git branch
# ブランチの作成
git branch [ブランチ名]
git checkout -b [ブランチ名]
# ブランチに移動
git checkout [ブランチ名]
# ブランチの削除
git branch -d [ブランチ名]
# ブランチをマージ
git checkout main
git merge [ブランチ名]
git rebase [ブランチ名] # 履歴の並び順が違うmerge
```

### PullRequest
- 他所のレポジトリに、変更を提案
- 変更するファイルが1個だけの場合は、GitHub上でやったほうが楽（後述）
- フォーク&ブランチ必須（いきなりmainにプルリクはできない）
- cf. https://biopackathon.slack.com/archives/C02LST7NUPM/p1637130529007000

```bash
# GitHub上でフォーク
# フォークしたレポジトリをローカルにコピー
git clone [https://github.com/自分のアカウント名/自分のレポジトリ名.git]
cd [自分のレポジトリ名]
# フォーク元のリモートレポジトリと連携させる
git remote add upstream [https://github.com/フォーク元のアカウント名/フォーク元レポジトリ名.git]
# ブランチを切る
git checkout -b [ブランチ名]
# 何かコードを変更
# プッシュ
git add --all
git commit -m [メッセージ]
git push --set-upstream origin [ブランチ名]
```

### Tag
- ある変更履歴に対して、わかりやすい名前を付ける（v1.0, 変更した内容など）
- ローカルでつけたタグは、GitHub上で確認できる
- cf. https://github.com/kokitsuyuzaki/reproducible-tools-exercise-r/tags

```bash
git tag -a [タグ名] -m [メッセージ文]
```

### コンフリクト
- リモートとローカルとで、辻褄が合わない時、`git`はどっちが正しいのか判断できず、`merge`ができない
	- 例: 同じファイルの同じ行に別々の修正が入った時
- `push`や`merge`時に、エラーメッセージが出て気付く
- 該当箇所を確認して、どちらを採用するか決める
- 該当ファイルを修正して、再度`push`、`merge`

## GitHub上での操作
### Actions
- GitHubが提供する継続的インテグレーション（CI）の枠組み
- `.github/workflow/適当な名前.yaml`というファイルを作るだけ
- リモートサーバ上で自動的にテストが実行される
- 実行結果は、ブラウザで確認できる
- 用語説明
  - **workflow**
    - 1つのYAMLファイルで書かれたjobの集合
    - *workflowは並列で実行される*
    - 依存関係を持たせたい場合は、専用のActionを使う cf. [wait-on-check](https://github.com/marketplace/actions/wait-on-check)
    - さらに、workflowは複数のjobで構成される
  - **job**
    - `jobs`タグで指定される処理
    - *jobは並列で実行される*
    - 依存関係を持たせたい場合は`needs`タグを使う
    - さらに、jobは複数のstepで構成される
  - **step**
    - `steps`タグで指定される処理
    - 具体的なコマンドをここに書く
    - *stepは上から順に実行される*
    - さらに、stepはActionとCommandに分類される
    - *step間では、処理の結果を共有できる*
  - **Action**
    - `uses`タグで指定される処理
      - GitHubが公開しているもの（e.g. `actions/checkout@v2`）+ 自作もできるらしい
      - パラメーターは`with`タグで渡す
      - [Marketplace](https://github.com/marketplace)でどのようなActionがあるのか見れる
  - **Command**
    - `run`タグで指定される処理
      - 普通にターミナルで実行するコマンド（e.g. `ls`）
  - **Event**
    - `on`タグで指定される、そのworkflowの実行条件
  - **Runner**
    - `runs-on`で指定される、そのjobを実行するマシン（e.g. `ubuntu-latest`）

### Pages
- `gh-pages`というブランチがリモート側で作成される
- https://アカウント名.github.io/レポジトリ名/ でドキュメントが公開される
### PullRequest（変更するファイルが一つの場合のみ）
- 変更したいファイル上で編集ボタン > Stat commit > Propose changes
### Clone
- あるリモートレポジトリをローカルにコピー
- 右上の"Code"ボタン > https://github.com/アカウント名/レポジトリ名.gitをコピー > ターミナルで`git clone *.git`
### Fork
- あるリモートレポジトリを自分のGitHubアカウント以下にも作成
- 右上の"Fork"ボタン
### Template
- レポジトリを作成する上での雛形
- cf. [BuildABiocWorkshop](https://github.com/seandavi/BuildABiocWorkshop) → [scTensor-workshop](https://github.com/kokitsuyuzaki/scTensor-workshop)
- Forkと似ているが、それまでの履歴は引き継がない
- テンプレートとして公開しているレポジトリで右上の"Use this template"ボタン
### Releases
- ほとんどタグと同じだが、正式にバージョンをつけて公開
- 右側のReleaseというところ
- タグに対して"Create release"
### Issues
- そのレポジトリに対する問い合わせ窓口
- 上の"Issues"ボタン
### Gist
- あえてレポジトリにするほどでも無いものを書くメモ
- https://gist.github.com
### バッジ
- CIの状況や、ダウンロード数など、そのツールを権威づけるもの
- cf. https://github.com/TomKellyGenetics/graphsim
- ZENODO: GitHubのコードに対して、DOIを発行（論文化の際にやっておいた方が良い）
### Project
- Backlogなど、プロジェクトの進捗状況を管理
### Packages
- 最近できた、GitHub上でコンテナを提供する枠組み（後述）

## `gh`コマンド集
- `git`はリモートと連携せずとも、それ自体がバージョン管理のツールとして成立している
- `git`の`push`先のレポジトリは複数（GitHub, GitLab, GitBeckect...etc）
- レポジトリごとにやれることは微妙に異なる
- つまり、`git`コマンドが、あらゆるレポジトリの操作を支援するのは得策ではない、そうあるべきでもない
- `gh`コマンドは、GitHubの操作により特化したコマンドを提供する、GitHub公式のCLI

### レポジトリ操作

```bash
mkdir test && cd test
git init # ローカルにtestレポジトリができる
gh repo create # リモートにもtestレポジトリができる
gh repo view # 確認
gh repo list # そのアカウントに関連づいたリモートレポジトリ一覧
echo "# test" > README.md
cd ..

# cli/cliからフォークしてkoki/cliを作りたい
gh repo fork cli/cli
# https://github.com/kokitsuyuzaki/cliができていることを確認

# deleteは2.2.0からの新機能
gh auth refresh -h github.com -s delete_repo
gh repo delete kokitsuyuzaki/cli
```

### Releases

```bash
cd test
echo "Hi" > Hi.txt
git add --all
git commit -m "Hi"
git push
gh release create v1.0.0
# https://github.com/kokitsuyuzaki/test/releases/tag/v1.0.0ができていることを確認
```

### PullRequest
- `git`の場合よりも完結、かなり多機能（Branchライクな操作が多数実装されている）

```bash
git branch branch1
git checkout branch1
echo "Hello" > Hello.txt
git add --all
git commit -m "Hello"
gh pr create
gh pr list
gh pr close 2
```

### Issues

```bash
cd test
gh issue create
gh issue list
gh issue close 4
```

### Actions
- リモートレポジトリ上のGitHub Actionsに対する操作

```bash
git clone https://github.com/kokitsuyuzaki/reproducible-tools-exercise-r
cd reproducible-tools-exercise-r
# これまでにリモートで実行されたワークフロー一覧
gh run list
# 特定のワークフローだけ再実行をリクエスト
gh run rerun 1493557930
```

- リモートでActionsを実行する`act`コマンドというのもあるが、シークレットなど、リモート固有な設定のところでやりづらそう

### Gist
```bash
echo "Test" > hoge.md
gh gist create --public hoge.md
gh gist list # ID一覧
gh gist delete d2f3e11b27f7d9f1c4072cbec8df5af8
```

## Git⇄Docker連携によるツール公開
- Git: バージョン管理
- Docker: 仮想環境（コンテナ）
- 対外的にはGitHub上でコードをオープンにしつつ、直ちに動く環境も配布したい
- 両者のいいとこどりはどのように実現できるか
- 以下の組み合わせで、幾つかやり方が考えられる

1. Dockerfileの置き場所
2. ビルドを誰がやるか
3. Dockerイメージのホスト先

### 1. Dockerfile内でGitHub上のコードを参照（一番簡単）
1. Dockerfileの置き場所: **docker buildを実行するところ**
2. ビルドを誰がやるか: **自分（手作業）**
3. Dockerイメージのホスト先: **DockerHub**
#### 手順
- 自前のスクリプトをGitHubに置く
- `curl`かDockerfileの`ADD`タグで取得
- `docker build`で作ったDockerイメージをDockerHubにプッシュ

### 2. DockerHubの自動ビルド機能（[有料プランのみ](https://docs.docker.com/docker-hub/builds/)）
1. Dockerfileの置き場所: **GitHub**
2. ビルドを誰がやるか: **DockerHub**
3. Dockerイメージのホスト先: **DockerHub**
#### 手順
- 自前のスクリプトをGitHubに置く
- DockerfileもGitHub上に置く
- DockerHubのサイト上でDockerfileを認識させる + 各種設定
- Dockerfileの変更がトリガーとなり、自動的にDockerHubにプッシュ
- 自分で毎回docker pushしない分楽

### 3. 2.をGitHub Actionsで行ったもの
1. Dockerfileの置き場所: **GitHub**
2. ビルドを誰がやるか: **GitHub Actions**
3. Dockerイメージのホスト先: **DockerHub**
#### 手順
- 自前のスクリプトをGitHubに置く
- DockerfileもGitHub上に置く
- GitHub ActionsでDockerイメージを作成し、DockerHubにプッシュ
- cf. [BuildABiocWorkshop](https://github.com/seandavi/BuildABiocWorkshop)

### 4. GitHub Packages/Container Registryを利用（ DockerHubを使わずに、全てGitHub上で一元管理する方針）
1. Dockerfileの置き場所: **GitHub**
2. ビルドを誰がやるか: **GitHub Actions**
3. Dockerイメージのホスト先: **GitHub**
- [GitHub Container Registry(GHCR)](https://docs.github.com/ja/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- GitHub Packages Registry（GPR）とは別のサービス
- ユーザー側からは、`docker pull ghcr.io/GitHubアカウント名/イメージ名:バージョン'として、普通に使える
#### 手順
- 自前のスクリプトをGitHubに置く
- DockerfileもGitHub上に置く
- GitHub ActionsでDockerイメージを作成し、GHCRにプッシュ
- cf. [reproducible-tools-exercise-r](https://github.com/kokitsuyuzaki/reproducible-tools-exercise-r), [cwl-log-generator](https://github.com/inutano/cwl-log-generator)
