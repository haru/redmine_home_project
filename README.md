# Redmine Home Project Plugin

Redmineのホーム画面を指定したプロジェクトの概要画面に変更するプラグインです。

## 機能

- Redmineのルート画面（`/`）を特定のプロジェクトの概要画面にリダイレクト
- プラグイン設定画面から簡単にホームプロジェクトを選択可能
- ユーザーの権限に応じた表示制御（ゲストユーザーは公開プロジェクトのみ）

## 要件

- Redmine 6.0 以上
- Ruby 3.x
- Rails 7.x

## インストール

1. プラグインディレクトリにクローン
   ```bash
   cd /path/to/redmine/plugins
   git clone [repository_url] redmine_home_project
   ```

2. Redmineを再起動
   ```bash
   touch /path/to/redmine/tmp/restart.txt
   ```

## 使い方

1. Redmine管理画面 > プラグイン > 「Redmine Home Project plugin」の「設定」をクリック
2. ホームプロジェクトとして表示したいプロジェクトを選択
3. 「保存」ボタンをクリック
4. Redmineのホーム画面（`/`）にアクセスすると、選択したプロジェクトの概要画面が表示されます

## アンインストール

```bash
rm -rf /path/to/redmine/plugins/redmine_home_project
touch /path/to/redmine/tmp/restart.txt
```

## ライセンス

MIT License

## 作者

Author Name
