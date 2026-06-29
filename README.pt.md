# rdpwrap-jh-auto-offsets

> **Offsets do RDP Wrapper para Windows 10/11, atualizados automaticamente todos os dias via CI.**

---

## 🌐 Idioma

| Idioma | Arquivo |
|--------|---------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | **README.pt.md** (este arquivo) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## O que é isso?

**RDP Wrapper** é um projeto de código aberto criado por [stascorp](https://github.com/stascorp/rdpwrap) que permite múltiplas sessões simultâneas de Remote Desktop (RDP) nas edições de consumidor do Windows (Home, Pro) — **sem modificar arquivos do sistema**.

Funciona injetando comportamento corrigido no `termsrv.dll` do Windows por meio de um arquivo de configuração chamado `rdpwrap.ini`, que contém deslocamentos de memória específicos para cada versão de build do Windows.

**O problema:** A Microsoft lança atualizações do Windows com frequência. A maioria dos repositórios comunitários depende de **uploads manuais** de novos offsets após cada Patch Tuesday.

**A solução deste repositório:** Um pipeline CI/CD totalmente automatizado com um runner Windows auto-hospedado que:

1. Executa diariamente e detecta a versão atual do `termsrv.dll`
2. Executa automaticamente o [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder)
3. Envia os novos offsets a este repositório em até 24 horas

---

## Início Rápido

> **Pré-requisitos:** Windows 10 ou 11, PowerShell 5.1+, privilégios de Administrador.

### Instalar (pela primeira vez)

Abra o PowerShell como **Administrador** e execute:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### Desinstalar

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

Este comando executará o `uninstall.bat` do próprio RDP Wrapper, removerá o diretório de instalação e reiniciará o Terminal Services. O Windows voltará ao seu comportamento padrão de sessão única.

### Atualizar offsets (após uma atualização do Windows)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### Verificar a instalação

Abra `C:\Program Files\RDP Wrapper\RDPConf.exe`. Você deve ver:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

---

## Créditos

- **[stascorp](https://github.com/stascorp/rdpwrap)** — Conceito original do RDP Wrapper
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — Ferramenta RDPWrapOffsetFinder
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — Repositório INI da comunidade

---

## Aviso Legal

Este projeto é apenas para **fins educacionais e de pesquisa**. O uso do RDP Wrapper pode violar os termos de licença do Windows da Microsoft. Os autores não assumem qualquer responsabilidade. Use por sua conta e risco.
