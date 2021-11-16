# Git × Docker
## 目次
- [XXX](XXXXX)
- [XXX](XXXXX)
- [XXX](XXXXX)
- [XXX](XXXXX)

## 準備
- **gitコマンド**
	- 大抵どこにでもあるが、MaxではXcodeのコマンドライン・デペロッパーツールが必要かも
	- ターミナルで`git --version`が動くか確認
- **GitHubアカウント**
	- なければ作成: https://github.co.jp
	- SSH認証の設定も必要
- **Dockerコマンド/DockerHub**
	- 前回の内容を確認

## Gitとは
- ファイルの変更履歴を記録・追跡する、バージョン管理ツール（VCS）
- ローカルレポジトリ: ローカルマシン上に作られたレポジトリ
- リモートレポジトリ: リモートサーバ上に作られたレポジトリ（GitHubなど）
- 関連技術
    - 集中型VCS: CVS, Subversion, Mercurial
        - 中央レポジトリ（リモートレポジトリ）が権限がある
        - コミットやチェックアウト（後述）といった操作は全て中央レポジトリに対して行われる
        - 対してGitは分散型VCSと呼ばれ、ローカルレポジトリに対しても、コマンドが実行可能
- GUIツールである程度対話的に操作可能
    - [Git GUI](https://git-scm.com/downloads/guis)
    - [Sourcetree](https://www.atlassian.com/ja/software/sourcetree)
    - [GitKraken](https://www.gitkraken.com)
    - ただし、今回はこれらは一切使わない

## GitHubとは
-
- 関連レポジトリ
    - BitBucket: XXXXX
    - GitLab: XXXXX
    - SourceForege: XXXXX
- 注意
    - パスワードから個人アクセストークンに変更

## gitコマンド集
### 初期設定

```bash
git config --global user.name "自分のGitHubアカウント名"
git config --global user.email "登録したメールアドレス"
```

### git管理の対象外ファイルを設定

```bash
echo ".DS_Store" > .gitignore
echo "._" >> .gitignore
```

### プル系

```bash
git clone
git pull
git fetch
git rebase
```

### プッシュ系

```bash
git add
git rm
git commit
git push
```

### 現状把握系

```bash
git status
git log
git log --graph
git diff
```

### ロールバック

```bash
git checkout
```

### ブランチ・タグ系
- 通常mainブランチ（旧masterブランチ）で作業している
- mainとは別のブランチを切って、そこでバージョン管理して、最後マージするという開発の仕方もある
- （一人で開発している時にはあまり使わない気もする）
- 複数人で同時に同じソフトウェア開発を行っているとする
- メインの開発方針 + 新規機能追加、デバッグなど、別のタスクが同時並行で走っている時、ブランチで分けておくと、整理しやすい
- または、一人で開発する場合でも、全作業を毎回ブランチを切って行い、一区切りついたら、mainにマージする（mainを汚さない方針）というやり方も

```bash
git branch ブランチ名
git branch -b ブランチ名
git tag
git release
git merge
git rebase
```

### 元の状態に戻す

```bash
git reset -hard ????
```

### コンフリクト
- リモートとローカルとで、辻褄が合わない時に、gitはpushができない
- push時に、エラーメッセージが出て気付く
- 該当ファイルを修正して、push

## GitHub上での操作
### フォーク
- XXXXX
- XXXXX
- XXXXX

### テンプレート
- XXXXX
- XXXXX
- XXXXX

### プルリク
- XXXXX
- XXXXX
- XXXXX

### Release
- XXXXX
- XXXXX
- XXXXX

### Issues
- XXXXX
- XXXXX
- XXXXX

### GitHub Actions
- XXXXX
- XXXXX
- XXXXX

### Pages
- XXXXX
- XXXXX
- XXXXX

### Gist
- XXXXX
- XXXXX
- XXXXX

## GitHub上にあるRコードをローカルで実行
- XXXXX
- XXXXX
- XXXXX
- XXXXX

## Dockerコンテナ内部に、GitHub上のコードを加える
- 自作スクリプト
    - ??????
    - ??????
    - ??????
    - ??????
    - ??????
- Rパッケージ（次回）: `remotes::install_github("アカウント名/パッケージ名")`

## 実例


