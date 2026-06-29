# rdpwrap-jh-auto-offsets

> **إزاحات RDP Wrapper لنظام Windows 10/11، يتم تحديثها تلقائياً يومياً عبر CI.**

---

## 🌐 اللغة

| اللغة | الملف |
|-------|-------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | [README.hi.md](README.hi.md) |
| 🇸🇦 العربية (Arabic) | **README.ar.md** (هذا الملف) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## ما هذا؟

**RDP Wrapper** هو مشروع مفتوح المصدر طوّره [stascorp](https://github.com/stascorp/rdpwrap)، يتيح فتح جلسات Remote Desktop (RDP) متعددة في آنٍ واحد على إصدارات Windows الاستهلاكية (Home, Pro) **دون تعديل ملفات النظام**.

يعمل عن طريق حقن سلوك مُرقَّع في `termsrv.dll` (خدمات Terminal) من خلال ملف تهيئة يُسمّى `rdpwrap.ini`، يحتوي على إزاحات ذاكرة خاصة بكل إصدار من إصدارات Windows.

**المشكلة:** تُصدر Microsoft تحديثات Windows بشكل متكرر، وقد يُرفق كل تحديث بـ `termsrv.dll` جديد بإزاحات ذاكرة مختلفة. تعتمد معظم المستودعات المجتمعية على **رفع يدوي** لملفات الإزاحات الجديدة بعد كل Patch Tuesday.

**الحل في هذا المستودع:** خط أنابيب CI/CD مؤتمت بالكامل يعمل على runner ذاتي الاستضافة يعمل بنظام Windows:

1. يكتشف يومياً إصدار `termsrv.dll` الحالي
2. يُشغّل تلقائياً [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder)
3. يُرسل الإزاحات الجديدة إلى هذا المستودع خلال 24 ساعة من التحديث

---

## البدء السريع

> **المتطلبات:** Windows 10 أو 11، PowerShell 5.1+، صلاحيات المسؤول (Administrator).

### التثبيت (للمرة الأولى)

افتح PowerShell **كمسؤول** ونفّذ:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### إلغاء التثبيت

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex
```

سيُشغّل هذا الأمر ملف `uninstall.bat` الخاص بـ RDP Wrapper، ويحذف مجلد التثبيت، ويُعيد تشغيل Terminal Services. سيعود Windows إلى سلوك RDP الافتراضي بجلسة واحدة.

### تحديث الإزاحات (بعد تحديث Windows)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### التحقق من التثبيت

افتح `C:\Program Files\RDP Wrapper\RDPConf.exe`. يجب أن تظهر:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

إذا ظهرت **"Not listening"**، شغّل سكريبت التحديث.

---

## الشكر والتقدير

- **[stascorp](https://github.com/stascorp/rdpwrap)** — المفهوم الأصلي لـ RDP Wrapper
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — أداة RDPWrapOffsetFinder
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — مستودع INI المجتمعي

---

## إخلاء المسؤولية

هذا المشروع لأغراض **تعليمية وبحثية** فقط. قد يُخالف استخدام RDP Wrapper شروط ترخيص Windows من Microsoft. لا يتحمل المؤلفون أي مسؤولية. استخدمه على مسؤوليتك الخاصة.
