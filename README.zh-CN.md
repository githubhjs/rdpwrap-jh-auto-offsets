# rdpwrap-jh-auto-offsets

> **适用于 Windows 10/11 的 RDP Wrapper 偏移量，每日通过 CI 自动更新。**

---

## 🌐 语言切换

| 语言 | 文件 |
|------|------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | **README.zh-CN.md**（本页） |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## 这是什么？

**RDP Wrapper** 是由 [stascorp](https://github.com/stascorp/rdpwrap) 开发的开源工具，允许在消费者版 Windows（家庭版、专业版）上同时建立多个远程桌面（RDP）连接，且**不修改系统文件**。

它通过名为 `rdpwrap.ini` 的配置文件，对 Windows 的 `termsrv.dll`（终端服务）注入修补行为。该配置文件包含针对每个 Windows 内部版本的特定内存偏移量。

**问题所在：** Microsoft 频繁发布 Windows 更新，每次更新可能推出新版 `termsrv.dll`，导致内存偏移量改变。大多数社区仓库依赖**人工手动上传**新的偏移量配置——这意味着用户在每次补丁日后可能面临数天的功能中断。

**本仓库的解决方案：** 部署了全自动 CI/CD 流程，通过自托管 Windows Runner：

1. 每日自动检测当前 `termsrv.dll` 版本
2. 自动运行 [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) 生成正确的内存偏移量
3. 在 Windows 更新后 24 小时内将新偏移量提交并推送至本仓库

---

## 功能特点

- ✅ **全自动化** — Windows 更新后无需人工干预
- ✅ **版本历史记录** — 每个内部版本的偏移量均存档于 `history/`
- ✅ **不修改系统二进制文件** — 使用原始 stascorp 可执行文件，仅生成 `.ini` 配置文件
- ✅ **低杀软误报率** — 避免修改可执行文件，不易触发 Windows Defender
- ✅ **一行命令安装与更新** — 为终端用户提供 PowerShell 一键命令
- ✅ **每日 CI 计划** — 自托管 Runner 每天台湾时间 14:00（UTC+8）自动检查新版本

---

## 快速开始

> **前提条件：** Windows 10 或 11、PowerShell 5.1+、管理员权限。

### 安装（首次）

以**管理员**身份打开 PowerShell，执行：

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### 更新偏移量（Windows 更新后）

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### 验证安装

安装完成后，打开 `C:\Program Files\RDP Wrapper\RDPConf.exe`，应看到：

- **Wrapper state：** Installed（已安装）
- **Service state：** Running（运行中）
- **Listener state：** Listening（监听中）

---

## 致谢

- **[stascorp](https://github.com/stascorp/rdpwrap)** — RDP Wrapper 原始概念与可执行文件
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder 工具
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — 社区 INI 仓库

---

## 免责声明

本项目仅供**教育与研究目的**。使用 RDP Wrapper 可能违反 Microsoft 对消费者版 Windows 的许可条款。作者不承担任何责任。请自行承担风险使用。
