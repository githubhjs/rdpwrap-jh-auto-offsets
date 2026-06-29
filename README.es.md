# rdpwrap-jh-auto-offsets

> **Offsets de RDP Wrapper para Windows 10/11, actualizados automáticamente cada día mediante CI.**

---

## 🌐 Idioma

| Idioma | Archivo |
|--------|---------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | **README.es.md** (este archivo) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## ¿Qué es esto?

**RDP Wrapper** es un proyecto de código abierto creado por [stascorp](https://github.com/stascorp/rdpwrap) que permite múltiples sesiones simultáneas de Escritorio Remoto (RDP) en ediciones de consumidor de Windows (Home, Pro), **sin modificar archivos del sistema**.

Funciona inyectando comportamiento parcheado en `termsrv.dll` de Windows mediante un archivo de configuración llamado `rdpwrap.ini`, que contiene desplazamientos de memoria específicos para cada versión de compilación de Windows.

**El problema:** Microsoft lanza actualizaciones de Windows con frecuencia. Cada actualización puede incluir un nuevo `termsrv.dll` con diferentes desplazamientos de memoria. La mayoría de los repositorios comunitarios dependen de **cargas manuales** de nuevos archivos de offsets después de cada Patch Tuesday.

**Esta solución:** Un pipeline CI/CD totalmente automatizado con un runner de Windows autohospedado que:

1. Se ejecuta diariamente y detecta la versión actual de `termsrv.dll`
2. Ejecuta automáticamente [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder)
3. Confirma y empuja los nuevos offsets a este repositorio dentro de las 24 horas

---

## Inicio Rápido

> **Requisitos:** Windows 10 u 11, PowerShell 5.1+, privilegios de Administrador.

### Instalar (primera vez)

Abra PowerShell como **Administrador** y ejecute:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### Desinstalar

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

Este comando ejecutará el `uninstall.bat` propio de RDP Wrapper, eliminará el directorio de instalación y reiniciará Terminal Services. Windows volverá a su comportamiento predeterminado de sesión única.

### Actualizar offsets (tras una actualización de Windows)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### Verificar la instalación

Abra `C:\Program Files\RDP Wrapper\RDPConf.exe`. Debería ver:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

Si el Listener muestra **"Not listening"**, ejecute el script de actualización.

---

## Solución de Problemas

### "Not listening" tras una actualización de Windows

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### Windows Defender elimina los archivos

Agregue una exclusión para `C:\Program Files\RDP Wrapper` en Seguridad de Windows → Exclusiones.

---

## Créditos

- **[stascorp](https://github.com/stascorp/rdpwrap)** — Concepto original y binarios de RDP Wrapper
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — Repositorio INI de la comunidad

---

## Descargo de Responsabilidad

Este proyecto es solo para **fines educativos e investigativos**. El uso de RDP Wrapper puede violar los términos de licencia de Windows de Microsoft. Los autores no asumen ninguna responsabilidad. Úselo bajo su propio riesgo.
