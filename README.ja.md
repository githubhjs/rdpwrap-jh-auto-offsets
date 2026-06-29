# rdpwrap-jh-auto-offsets

> **Windows 10/11 向け RDP Wrapper オフセット、CI によって毎日自動更新されます。**

---

## 🌐 言語

| 言語 | ファイル |
|------|---------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | **README.ja.md**（このファイル） |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## これは何ですか？

**RDP Wrapper** は [stascorp](https://github.com/stascorp/rdpwrap) によって作成されたオープンソースプロジェクトで、**システムファイルを変更せずに**、コンシューマー版 Windows（Home、Pro）で複数の同時 Remote Desktop（RDP）セッションを可能にします。

`rdpwrap.ini` という設定ファイルを通じて Windows の `termsrv.dll`（ターミナルサービス）にパッチ済みの動作を注入することで機能します。このファイルには各 Windows ビルドバージョン固有のメモリオフセットが含まれています。

**問題点：** Microsoft は頻繁に Windows アップデートをリリースします。各アップデートで新しい `termsrv.dll` が配布され、メモリオフセットが変わる場合があります。ほとんどのコミュニティリポジトリは、Patch Tuesday ごとに**手動アップロード**に依存しています。

**このリポジトリの解決策：** セルフホスト型 Windows ランナーを使用した完全自動化 CI/CD パイプライン：

1. 毎日 `termsrv.dll` のバージョンを検出
2. [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) を自動実行
3. Windows アップデートから 24 時間以内に新しいオフセットを push

---

## クイックスタート

> **前提条件：** Windows 10 または 11、PowerShell 5.1+、管理者権限。

### インストール（初回）

**管理者として** PowerShell を開き、実行：

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### オフセットの更新（Windows アップデート後）

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### インストールの確認

`C:\Program Files\RDP Wrapper\RDPConf.exe` を開きます。以下が表示されるはずです：

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

**"Not listening"** が表示される場合は、更新スクリプトを実行してください。

---

## リポジトリ構造

```
rdpwrap-jh-auto-offsets/
├── .github/workflows/check-update.yml  # 毎日の CI ワークフロー
├── bin/                                 # RDPWrapOffsetFinder バイナリ（64 ビット）
├── history/                             # ビルドごとのオフセットスナップショット
├── rdpwrap.ini                          # 最新の統合オフセット（自動更新）
├── install.ps1                          # ワンクリックインストーラー
└── update.ps1                           # ワンクリック更新スクリプト
```

---

## クレジット

- **[stascorp](https://github.com/stascorp/rdpwrap)** — RDP Wrapper のオリジナルコンセプトとバイナリ
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder ツール
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — コミュニティ INI リポジトリ

---

## 免責事項

このプロジェクトは**教育および研究目的のみ**を対象としています。RDP Wrapper の使用は、Microsoft の Windows ライセンス条項に違反する可能性があります。作者はいかなる責任も負いません。自己責任でご使用ください。
