# rdpwrap-jh-auto-offsets

> **適用於 Windows 10/11 的 RDP Wrapper 位移量，每日透過 CI 自動更新。**

---

## 🌐 語言切換

| 語言 | 檔案 |
|------|------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | **README.zh-TW.md**（本頁） |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## 這是什麼？

**RDP Wrapper** 是由 [stascorp](https://github.com/stascorp/rdpwrap) 開發的開源工具，允許在消費者版 Windows（家用版、專業版）上同時建立多個遠端桌面（RDP）連線，且**不修改系統檔案**。

它的運作方式是透過一個名為 `rdpwrap.ini` 的設定檔，對 Windows 的 `termsrv.dll`（終端機服務）注入修補行為。該設定檔包含針對每個 Windows 組建版本的特定記憶體位移量（offset）。

**問題所在：** Microsoft 頻繁發布 Windows 更新，每次更新都可能推出新版的 `termsrv.dll`，導致記憶體位移量改變。大多數社群儲存庫都依賴**人工手動上傳**新的位移量設定——這意味著使用者在每次 Patch Tuesday 後可能面臨數天的功能中斷。

**本儲存庫的解決方案：** 部署了一個全自動 CI/CD 流程，透過自架的 Windows Runner：

1. 每日自動偵測目前的 `termsrv.dll` 版本
2. 自動執行 [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) 產生正確的記憶體位移量
3. 在 Windows 更新後 24 小時內將新位移量 commit 並 push 至本儲存庫

---

## 功能特點

- ✅ **全自動化** — Windows 更新後無需人工介入
- ✅ **版本歷史記錄** — 每個組建版本的位移量均歸檔於 `history/`
- ✅ **不修改系統二進位檔** — 使用原始 stascorp 執行檔，僅產生 `.ini` 設定檔
- ✅ **低防毒誤報率** — 避免修改執行檔，較不容易觸發 Windows Defender
- ✅ **一行指令安裝與更新** — 提供 PowerShell 一鍵指令給終端使用者
- ✅ **每日 CI 排程** — 自架 Runner 每天台灣時間 14:00（UTC+8）自動檢查新版本

---

## 快速開始

> **前提條件：** Windows 10 或 11、PowerShell 5.1+、系統管理員權限。

### 安裝（第一次）

以**系統管理員**身分開啟 PowerShell，執行：

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

此指令將會：
1. 從 stascorp 下載原始 RDP Wrapper v1.6.2 執行檔
2. 從本儲存庫下載最新的 `rdpwrap.ini`
3. 安裝 RDP Wrapper Windows 服務

### 更新位移量（Windows 更新後）

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

此指令將會：
1. 停止終端機服務
2. 從本儲存庫下載最新的 `rdpwrap.ini`
3. 重新啟動終端機服務

### 移除安裝

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

此指令將執行 RDP Wrapper 內建的 `uninstall.bat`，移除安裝目錄，並重新啟動 Terminal Services。Windows 將恢復預設的單一 RDP 連線行為。

### 驗證安裝

安裝完成後，開啟 `C:\Program Files\RDP Wrapper\RDPConf.exe`。應看到：

- **Wrapper state：** Installed（已安裝）
- **Service state：** Running（執行中）
- **Listener state：** Listening（監聽中）

若 Listener 顯示 **"Not listening"** 或 **"[not supported]"**，請執行上方的更新指令。

---

## CI 運作原理

```
每日台灣時間 14:00（UTC+8）
        │
        ▼
自架 Windows Runner（你的機器）
        │
        ├── 執行 RDPWrapOffsetFinder.exe
        │         │
        │         └── 讀取 System32 的 termsrv.dll
        │             從 Microsoft 下載 PDB 符號檔
        │             輸出記憶體位移量
        │
        ├── 解析輸出中的 [section] 區塊
        │
        ├── 對每個新區塊（不在 history/ 中）：
        │       ├── 寫入 history/<版本>.ini
        │       └── 附加至 rdpwrap.ini
        │
        └── 若有新區塊 → git commit + push
```

---

## 儲存庫結構

```
rdpwrap-jh-auto-offsets/
├── .github/
│   └── workflows/
│       └── check-update.yml     # 每日 CI 工作流程
├── bin/                         # RDPWrapOffsetFinder 執行檔（64 位元）
├── history/                     # 各組建版本的位移量快照
├── README.md                    # 英文版說明
├── README.zh-TW.md              # 繁體中文版說明（本頁）
├── rdpwrap.ini                  # 最新綜合位移量（自動更新）
├── install.ps1                  # 一鍵安裝腳本
└── update.ps1                   # 一鍵更新腳本
```

---

## 了解 `rdpwrap.ini` 格式

```ini
[10.0.26100.8521]
SingleUserPatch.x64=1
SingleUserOffset.x64=9F39B
SingleUserCode.x64=mov_eax_1_nop_2
DefPolicyPatch.x64=1
DefPolicyOffset.x64=9C53D
DefPolicyCode.x64=CDefPolicy_Query_r9d_rdi_jmp
LocalOnlyPatch.x64=1
LocalOnlyOffset.x64=920F1
LocalOnlyCode.x64=jmpshort
SLInitHook.x64=1
SLInitOffset.x64=B3468
SLInitFunc.x64=New_CSLQuery_Initialize

[10.0.26100.8521-SLInit]
bServerSku.x64=126FCC
bRemoteConnAllowed.x64=126FE4
...
```

每個區塊對應一個特定的 Windows 組建（`主版本.次版本.組建.修訂`）。RDP Wrapper 在服務啟動時讀取此檔案，並針對目前執行的 OS 版本套用正確的修補。

---

## 疑難排解

### Windows 更新後顯示「Not listening」

執行更新腳本：
```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

若 Windows 更新非常近期（24 小時內），CI 可能尚未執行。請查看 [Actions](https://github.com/githubhjs/rdpwrap-jh-auto-offsets/actions) 確認最新執行狀態。

### Windows Defender 刪除了檔案

在 Windows 安全性 → 病毒與威脅防護 → 管理設定 → 排除項目，為 `C:\Program Files\RDP Wrapper` 新增排除項目。

### 多位使用者無法同時連線

確認：
1. RDPConf.exe 中 Listener 顯示「Listening」
2. 每位使用者使用**不同的 Windows 使用者帳戶**連線

---

## 與其他專案比較

| 專案 | 自動更新 | 方法 | 防毒問題 | 狀態 |
|------|---------|------|---------|------|
| [stascorp/rdpwrap](https://github.com/stascorp/rdpwrap) | ❌ 手動 | INI | 低 | 已停止維護（2017） |
| [sebaxakerhtc/rdpwrap.ini](https://github.com/sebaxakerhtc/rdpwrap.ini) | ❌ 手動（社群） | INI | 低 | 活躍中 |
| [sergiye/rdpWrapper](https://github.com/sergiye/rdpWrapper) | ✅ 自動（本機） | .NET 改寫 | 高（Defender） | 活躍中 |
| **rdpwrap-jh-auto-offsets**（本儲存庫） | ✅ **自動（雲端 CI）** | CI + INI | 低 | 活躍中 |

---

## 致謝

- **[stascorp](https://github.com/stascorp/rdpwrap)** — RDP Wrapper 原始概念與執行檔
- **[binarymaster & Nameksmyth](https://github.com/stascorp/rdpwrap)** — 原始程式碼的主要貢獻者
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder，使自動化成為可能的核心引擎
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — 社群 INI 儲存庫，作為初始基礎

---

## 免責聲明

本專案僅供**教育與研究目的**。使用 RDP Wrapper 可能違反 Microsoft 對消費者版 Windows 的授權條款。作者對任何授權違規或系統問題不承擔任何責任。請在持有適當授權的環境中自行承擔風險使用。

---

## 授權

本儲存庫中的腳本以 **MIT 授權條款**發布。`bin/` 目錄中包含的工具遵循其各自上游專案的授權條款。
