# rdpwrap-jh-auto-offsets

> **Windows 10/11-এর জন্য RDP Wrapper অফসেট, CI-এর মাধ্যমে প্রতিদিন স্বয়ংক্রিয়ভাবে আপডেট হয়।**

---

## 🌐 ভাষা

| ভাষা | ফাইল |
|------|------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | **README.bn.md** (এই ফাইল) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## এটি কী?

**RDP Wrapper** হলো [stascorp](https://github.com/stascorp/rdpwrap)-এর তৈরি একটি ওপেন-সোর্স প্রকল্প যা Windows-এর কনজিউমার সংস্করণে (Home, Pro) **সিস্টেম ফাইল পরিবর্তন না করে** একাধিক সমসাময়িক Remote Desktop (RDP) সেশনের অনুমতি দেয়।

এটি `rdpwrap.ini` নামক একটি কনফিগারেশন ফাইলের মাধ্যমে Windows-এর `termsrv.dll`-এ প্যাচ করা আচরণ ইনজেক্ট করে কাজ করে, যেখানে প্রতিটি Windows বিল্ড সংস্করণের জন্য নির্দিষ্ট মেমোরি অফসেট থাকে।

**সমস্যা:** Microsoft ঘন ঘন Windows আপডেট প্রকাশ করে। বেশিরভাগ কমিউনিটি রিপোজিটরি প্রতিটি Patch Tuesday-এর পরে **ম্যানুয়াল আপলোড**-এর উপর নির্ভর করে।

**এই রিপোজিটরির সমাধান:** একটি সম্পূর্ণ স্বয়ংক্রিয় CI/CD পাইপলাইন:

1. প্রতিদিন `termsrv.dll` সংস্করণ সনাক্ত করে
2. স্বয়ংক্রিয়ভাবে [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) চালায়
3. Windows আপডেটের ২৪ ঘণ্টার মধ্যে নতুন অফসেট push করে

---

## দ্রুত শুরু

> **পূর্বশর্ত:** Windows 10 বা 11, PowerShell 5.1+, Administrator সুবিধা।

### ইনস্টল করুন (প্রথমবার)

**Administrator** হিসেবে PowerShell খুলুন এবং চালান:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### আনইনস্টল করুন

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

এই কমান্ডটি RDP Wrapper-এর নিজস্ব `uninstall.bat` চালাবে, ইনস্টল ডিরেক্টরি মুছবে এবং Terminal Services পুনরায় চালু করবে। Windows তার ডিফল্ট একক-সেশন RDP আচরণে ফিরে যাবে।

### অফসেট আপডেট করুন (Windows আপডেটের পরে)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

---

## কৃতজ্ঞতা

- **[stascorp](https://github.com/stascorp/rdpwrap)** — RDP Wrapper-এর মূল ধারণা
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder টুল
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — কমিউনিটি INI রিপোজিটরি

---

## দায়বর্জন

এই প্রকল্পটি শুধুমাত্র **শিক্ষামূলক ও গবেষণামূলক উদ্দেশ্যে**। RDP Wrapper ব্যবহার Microsoft-এর Windows লাইসেন্সিং শর্ত লঙ্ঘন করতে পারে। লেখকরা কোনো দায়িত্ব নেন না। নিজ ঝুঁকিতে ব্যবহার করুন।
