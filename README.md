# ticket-amount-calculator

- チケットの合計金額を計算するプログラムである
- Ruby CLIとして動作するため、Rubyの実行環境が必要である

## 実行環境

### Vagrantを使用する場合

- ホストOSに `VirtualBox` をインストールしている（ `v7.0` 以上を推奨）
- ホストOSに `Vagrant` をインストールしている（ `v2.2.15` 以上を推奨）

#### ゲストOS構築

```bash
[HOST]

cd ${PROJECT_ROOT}
vagrant up
vagrant rsync-auto
```

- `vagrant up` が完了すると、ゲストOS上でDockerコンテナが起動している
- `vagrant rsync-auto` を実行しておくと、ファイルの同期を取る（ホストOS → ゲストOSの片方向のみ）

### Dockerを使用する場合

- ホストOSに `Docker` をインストールしている
- ホストOSに `Docker Compose` をインストールしている

#### コンテナ構築

```bash
[HOST]

cd ${PROJECT_ROOT}/docker
docker-compose up -d
```

- `docker-compose up -d` 実行後、Dockerコンテナが起動していることを確認する

### 直接コマンドを実行する場合

- `Ruby` をインストールしている（ `v3.2.2` を想定）
- `Bundler` をインストールしている（ `v2.3.26` を想定）

### 補足事項

#### ゲストOS → ホストOSでファイルを同期する

ゲストOSで追加、変更したファイルをホストOSに反映させたい場合、以下のコマンドを実行する。

自動的には同期しないため、毎回手動で実行させる必要がある。

```
vagrant rsync-back
```

#### Makefile

使用頻度の高いコマンドを `make ターゲット名` で実行できるようにしている。

`make help` で、ターゲットの説明を確認できる。

```bash
bash-app                       docker-compose run --rm app /bin/bash
build                          docker-compose build --no-cache
down-app                       docker-compose down app
down                           docker-compose down
exec-bash-app                  docker-compose exec app /bin/bash
rm-app                         docker-compose rm -fsv app
up-app-build                   docker-compose up --build app
up-app                         docker-compose up app
up-build-d                     docker-compose up --build -d
up-d                           docker-compose up -d
```

## 実行コマンド

以下のコマンドを実行する。

```bash
cd ${PROJECT_ROOT}/app
ruby exe/ticket_amount.rb -t ${TICKET_TYPE}

TICKET_TYPE: 1: 通常, 2: 特別 （デフォルト: 1）
```

対話形式で入力を受け付けるので、入力を行う。

- チケット枚数（大人）
- チケット枚数（子供）
- チケット枚数（シニア）
- 特別条件

入力が完了すると、チケットの合計金額が表示される。

- 変更前合計金額
- 販売合計金額
- 金額変更明細
