# rdpwrap-jh-auto-offsets

> **Auto-generated RDP Wrapper offsets for Windows 10/11, updated daily via CI.**

---

## 🌐 Language / 语言 / Idioma / Langue / Idioma / Язык / भाषा / 言語 / اللغة / ভাষা

| Language | File |
|----------|------|
| 🇺🇸 English | **README.md** (this file) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
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

## What is this?

**RDP Wrapper** is an open-source project by [stascorp](https://github.com/stascorp/rdpwrap) that allows multiple simultaneous Remote Desktop (RDP) sessions on consumer editions of Windows (Home, Pro) — without modifying system files.

It works by injecting patched behavior into Windows' `termsrv.dll` (Terminal Services) using a configuration file called `rdpwrap.ini`, which contains memory offsets specific to each Windows build version.

**The problem:** Microsoft releases Windows updates frequently. Each update may ship a new `termsrv.dll` with different memory offsets. The original RDP Wrapper project and most community repositories rely on **manual human uploads** of new offset files after each Patch Tuesday — which means users can be left with a broken setup for days.

**This repository solves that problem** with a fully automated CI/CD pipeline running on a self-hosted Windows runner that:

1. Runs daily and detects the current `termsrv.dll` version
2. Automatically runs [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) to generate correct memory offsets
3. Commits and pushes new offsets to this repository within 24 hours of a Windows update

---

## Features

- ✅ **Fully automated** — no manual human intervention needed after Windows updates
- ✅ **Per-version history** — every build's offsets are archived in `history/`
- ✅ **No modified binaries** — uses original stascorp binaries, only the `.ini` config is generated
- ✅ **Low AV friction** — avoids rewriting executables, less likely to trigger Windows Defender
- ✅ **One-command install & update** — PowerShell one-liners for end users
- ✅ **Daily CI schedule** — self-hosted runner checks for new builds every day at 14:00 Taiwan time (UTC+8)

---

## Quick Start

> **Prerequisites:** Windows 10 or 11, PowerShell 5.1+, Administrator privileges.

### Install (first time)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

This will:
1. Download the original RDP Wrapper v1.6.2 binaries from stascorp
2. Download the latest `rdpwrap.ini` from this repository
3. Install the RDP Wrapper Windows service

### Update offsets (after a Windows update)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

This will:
1. Stop Terminal Services
2. Download the latest `rdpwrap.ini` from this repository
3. Restart Terminal Services

### Uninstall

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

This will run RDP Wrapper's own `uninstall.bat`, remove the install directory, and restart Terminal Services. Windows returns to its default single-session RDP behavior.

### Verify the installation

After installing, open `RDPConf.exe` from `C:\Program Files\RDP Wrapper`. You should see:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

If the listener shows **"Not listening"** or **"[not supported]"**, run the update script above.

---

## How the CI Works

```
Daily at 14:00 Taiwan Time (UTC+8)
        │
        ▼
Self-hosted Windows Runner (your machine)
        │
        ├── Run RDPWrapOffsetFinder.exe
        │         │
        │         └── Reads termsrv.dll from System32
        │             Downloads PDB symbols from Microsoft
        │             Outputs memory offsets
        │
        ├── Parse [section] blocks from output
        │
        ├── For each NEW section (not in history/):
        │       ├── Write to history/<version>.ini
        │       └── Append to rdpwrap.ini
        │
        └── If new sections found → git commit + push
```

### Key Design Decisions

| Decision | Reason |
|----------|--------|
| Use original stascorp binaries | Maximum compatibility, lowest AV false positive rate |
| Use `RDPWrapOffsetFinder` (not manual) | Auto-generates offsets without reverse-engineering knowledge |
| History per-version in `history/` | Users can pin to a specific Windows build if needed |
| Self-hosted runner | GitHub-hosted runners don't have real consumer `termsrv.dll` |
| PAT in repo secret | `github-actions[bot]` doesn't have write access to public repos by default |

---

## Repository Structure

```
rdpwrap-jh-auto-offsets/
├── .github/
│   └── workflows/
│       └── check-update.yml     # Daily CI workflow
├── bin/                         # RDPWrapOffsetFinder binaries (64-bit)
│   ├── RDPWrapOffsetFinder.exe
│   ├── Zydis.dll
│   ├── dbghelp.dll
│   ├── symsrv.dll
│   └── symsrv.yes
├── history/                     # Per-build offset snapshots
│   ├── 10.0.26100.8521.ini
│   └── 10.0.26100.8521-SLInit.ini
├── README.md                    # This file (English)
├── README.zh-TW.md              # Traditional Chinese
├── README.zh-CN.md              # Simplified Chinese
├── README.es.md                 # Spanish
├── ... (other languages)
├── rdpwrap.ini                  # Latest combined offsets (auto-updated)
├── install.ps1                  # One-click installer
└── update.ps1                   # One-click offset updater
```

---

## Understanding `rdpwrap.ini`

The `rdpwrap.ini` file contains sections like:

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

Each section corresponds to a specific Windows build (`Major.Minor.Build.Revision`). RDP Wrapper reads this file at service start and applies the correct patch for your running OS version.

---

## Troubleshooting

### "Not listening" after Windows Update

Run the update script:
```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

If the update was very recent (within the last 24 hours), the CI may not have run yet. Check [Actions](https://github.com/githubhjs/rdpwrap-jh-auto-offsets/actions) for the latest run, or manually trigger it.

### Windows Defender removes files

Add an exclusion for `C:\Program Files\RDP Wrapper` in Windows Security → Virus & threat protection → Manage settings → Exclusions.

### RDPConf.exe shows "Wrapper state: Not installed"

Re-run the install script as Administrator.

### Multiple users can't connect simultaneously

Make sure:
1. RDP Wrapper listener shows "Listening" in RDPConf.exe
2. You have not reached your hardware session limit
3. Each user connects with a **different Windows user account**

---

## Comparison with Other Projects

| Project | Auto-update | Method | AV Issues | Status |
|---------|-------------|--------|-----------|--------|
| [stascorp/rdpwrap](https://github.com/stascorp/rdpwrap) | ❌ Manual | INI | Low | Abandoned (2017) |
| [sebaxakerhtc/rdpwrap.ini](https://github.com/sebaxakerhtc/rdpwrap.ini) | ❌ Manual (community) | INI | Low | Active |
| [sergiye/rdpWrapper](https://github.com/sergiye/rdpWrapper) | ✅ Auto (local) | .NET rewrite | High (Defender) | Active |
| [asmtron/rdpwrap](https://github.com/asmtron/rdpwrap) | ✅ Auto (local) | Script | Medium | Active |
| **rdpwrap-jh-auto-offsets** (this repo) | ✅ **Auto (cloud CI)** | CI + INI | Low | Active |

---

## Credits & Acknowledgements

- **[stascorp](https://github.com/stascorp/rdpwrap)** — Original RDP Wrapper concept and binaries
- **[binarymaster & Nameksmyth](https://github.com/stascorp/rdpwrap)** — Key contributors to the original codebase
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder, the engine that makes automation possible
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — Community INI repository used as the initial base

---

## Disclaimer

This project is for **educational and research purposes**. Using RDP Wrapper may violate Microsoft's Windows licensing terms on consumer SKUs. The authors take no responsibility for any licensing violations or system issues. Use at your own risk in environments where you hold the appropriate licenses.

---

## License

The scripts in this repository are released under the **MIT License**. The bundled `bin/` directory contains tools from their respective upstream projects under their own licenses.
