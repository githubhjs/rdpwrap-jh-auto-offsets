# rdpwrap-jh-auto-offsets

> **Офсеты RDP Wrapper для Windows 10/11, автоматически обновляемые ежедневно через CI.**

---

## 🌐 Язык

| Язык | Файл |
|------|------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | **README.ru.md** (этот файл) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## Что это такое?

**RDP Wrapper** — это проект с открытым исходным кодом от [stascorp](https://github.com/stascorp/rdpwrap), который позволяет использовать несколько одновременных сессий Remote Desktop (RDP) на потребительских версиях Windows (Home, Pro) **без изменения системных файлов**.

Он работает путём внедрения исправленного поведения в `termsrv.dll` Windows через файл конфигурации `rdpwrap.ini`, содержащий смещения памяти (офсеты), специфичные для каждой версии сборки Windows.

**Проблема:** Microsoft часто выпускает обновления Windows. Каждое обновление может содержать новый `termsrv.dll` с другими смещениями памяти. Большинство общественных репозиториев зависит от **ручной загрузки** новых файлов офсетов после каждого Patch Tuesday.

**Решение этого репозитория:** Полностью автоматизированный CI/CD-конвейер на базе самоуправляемого Windows-раннера:

1. Ежедневно определяет текущую версию `termsrv.dll`
2. Автоматически запускает [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder)
3. Публикует новые офсеты в течение 24 часов после обновления Windows

---

## Быстрый старт

> **Требования:** Windows 10 или 11, PowerShell 5.1+, права Администратора.

### Установка (первый раз)

Откройте PowerShell от имени **Администратора** и выполните:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### Удаление

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

Эта команда запустит собственный `uninstall.bat` RDP Wrapper, удалит директорию установки и перезапустит Terminal Services. Windows вернётся к стандартному поведению с одной RDP-сессией.

### Обновление офсетов (после обновления Windows)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### Проверка установки

Откройте `C:\Program Files\RDP Wrapper\RDPConf.exe`. Вы должны увидеть:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

Если Listener показывает **"Not listening"**, запустите скрипт обновления.

---

## Благодарности

- **[stascorp](https://github.com/stascorp/rdpwrap)** — Оригинальная концепция RDP Wrapper
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — Инструмент RDPWrapOffsetFinder
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — Сообщественный INI-репозиторий

---

## Отказ от ответственности

Этот проект предназначен **только для образовательных и исследовательских целей**. Использование RDP Wrapper может нарушать условия лицензирования Windows от Microsoft. Авторы не несут никакой ответственности. Используйте на свой страх и риск.
