# rdpwrap-jh-auto-offsets

> **Offsets RDP Wrapper pour Windows 10/11, mis à jour automatiquement chaque jour via CI.**

---

## 🌐 Langue

| Langue | Fichier |
|--------|---------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | **README.fr.md** (ce fichier) |

---

## Qu'est-ce que c'est ?

**RDP Wrapper** est un projet open source créé par [stascorp](https://github.com/stascorp/rdpwrap) qui permet plusieurs sessions Remote Desktop (RDP) simultanées sur les éditions grand public de Windows (Home, Pro) — **sans modifier les fichiers système**.

Il fonctionne en injectant un comportement patché dans `termsrv.dll` de Windows via un fichier de configuration appelé `rdpwrap.ini`, qui contient des décalages mémoire (offsets) spécifiques à chaque version de build Windows.

**Le problème :** Microsoft publie fréquemment des mises à jour Windows. Chaque mise à jour peut inclure un nouveau `termsrv.dll` avec des offsets différents. La plupart des dépôts communautaires dépendent de **téléchargements manuels** après chaque Patch Tuesday.

**La solution de ce dépôt :** Un pipeline CI/CD entièrement automatisé sur un runner Windows auto-hébergé :

1. Détecte quotidiennement la version actuelle de `termsrv.dll`
2. Exécute automatiquement [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder)
3. Envoie les nouveaux offsets dans ce dépôt dans les 24 heures

---

## Démarrage Rapide

> **Prérequis :** Windows 10 ou 11, PowerShell 5.1+, droits Administrateur.

### Installation (première fois)

Ouvrez PowerShell en tant qu'**Administrateur** et exécutez :

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### Mise à jour des offsets (après une mise à jour Windows)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### Vérifier l'installation

Ouvrez `C:\Program Files\RDP Wrapper\RDPConf.exe`. Vous devriez voir :

- **Wrapper state :** Installed
- **Service state :** Running
- **Listener state :** Listening

Si Listener affiche **"Not listening"**, exécutez le script de mise à jour.

---

## Remerciements

- **[stascorp](https://github.com/stascorp/rdpwrap)** — Concept original et binaires de RDP Wrapper
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — Outil RDPWrapOffsetFinder
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — Dépôt INI communautaire

---

## Avertissement

Ce projet est uniquement à des **fins éducatives et de recherche**. L'utilisation de RDP Wrapper peut violer les conditions de licence Windows de Microsoft. Les auteurs déclinent toute responsabilité. Utilisez à vos propres risques.
