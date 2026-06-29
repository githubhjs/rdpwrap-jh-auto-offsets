# rdpwrap-jh-auto-offsets

Auto-generated RDP Wrapper offsets for Windows 10/11, updated daily via CI.

A self-hosted GitHub Actions runner monitors `termsrv.dll` version changes and automatically runs [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) to generate new offsets — no waiting for manual uploads after Patch Tuesday.

## Quick Start

**Install** (PowerShell as Administrator):
```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

**Update offsets after a Windows update** (PowerShell as Administrator):
```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

## How It Works

1. A self-hosted Windows runner checks `termsrv.dll` version daily at 14:00 Taiwan time
2. If a new build is detected, `RDPWrapOffsetFinder.exe` generates the correct memory offsets
3. The result is committed to `rdpwrap.ini` and archived in `history/<version>.ini`
4. Users just pull the latest `rdpwrap.ini` — no local tools needed

## Files

| File | Description |
|------|-------------|
| `rdpwrap.ini` | Latest combined offsets (auto-updated) |
| `history/<version>.ini` | Per-build offset snapshots |
| `install.ps1` | One-click installer |
| `update.ps1` | Pull latest offsets and restart Terminal Services |
| `bin/` | RDPWrapOffsetFinder binaries (64-bit) |

## Credits

- [stascorp/rdpwrap](https://github.com/stascorp/rdpwrap) — original RDP Wrapper
- [llccd/RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) — offset finder engine
- [sebaxakerhtc/rdpwrap.ini](https://github.com/sebaxakerhtc/rdpwrap.ini) — initial INI base
