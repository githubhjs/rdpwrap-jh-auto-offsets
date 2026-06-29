# rdpwrap-jh-auto-offsets

> **Windows 10/11 के लिए RDP Wrapper ऑफसेट, CI के माध्यम से प्रतिदिन स्वचालित रूप से अपडेट किए जाते हैं।**

---

## 🌐 भाषा

| भाषा | फ़ाइल |
|------|-------|
| 🇺🇸 English | [README.md](README.md) |
| 🇹🇼 繁體中文 (Traditional Chinese) | [README.zh-TW.md](README.zh-TW.md) |
| 🇨🇳 简体中文 (Simplified Chinese) | [README.zh-CN.md](README.zh-CN.md) |
| 🇪🇸 Español (Spanish) | [README.es.md](README.es.md) |
| 🇮🇳 हिन्दी (Hindi) | **README.hi.md** (यह फ़ाइल) |
| 🇸🇦 العربية (Arabic) | [README.ar.md](README.ar.md) |
| 🇧🇩 বাংলা (Bengali) | [README.bn.md](README.bn.md) |
| 🇧🇷 Português (Portuguese) | [README.pt.md](README.pt.md) |
| 🇷🇺 Русский (Russian) | [README.ru.md](README.ru.md) |
| 🇯🇵 日本語 (Japanese) | [README.ja.md](README.ja.md) |
| 🇫🇷 Français (French) | [README.fr.md](README.fr.md) |

---

## यह क्या है?

**RDP Wrapper** [stascorp](https://github.com/stascorp/rdpwrap) द्वारा बनाया गया एक ओपन-सोर्स प्रोजेक्ट है जो Windows के उपभोक्ता संस्करणों (Home, Pro) पर **सिस्टम फ़ाइलों को संशोधित किए बिना** एकाधिक समवर्ती Remote Desktop (RDP) सत्रों की अनुमति देता है।

यह `rdpwrap.ini` नामक एक कॉन्फ़िगरेशन फ़ाइल के माध्यम से Windows के `termsrv.dll` (टर्मिनल सेवाएं) में पैच किए गए व्यवहार को इंजेक्ट करके काम करता है, जिसमें प्रत्येक Windows बिल्ड संस्करण के लिए विशिष्ट मेमोरी ऑफसेट होते हैं।

**समस्या:** Microsoft बार-बार Windows अपडेट जारी करता है। प्रत्येक अपडेट नए `termsrv.dll` के साथ आ सकता है। अधिकांश समुदाय रिपॉजिटरी Patch Tuesday के बाद **मैन्युअल अपलोड** पर निर्भर करती हैं।

**यह रिपॉजिटरी** एक पूरी तरह से स्वचालित CI/CD पाइपलाइन के साथ इस समस्या का समाधान करती है:

1. प्रतिदिन `termsrv.dll` संस्करण का पता लगाना
2. [RDPWrapOffsetFinder](https://github.com/llccd/RDPWrapOffsetFinder) को स्वचालित रूप से चलाना
3. Windows अपडेट के 24 घंटे के भीतर नए ऑफसेट push करना

---

## त्वरित प्रारंभ

> **आवश्यकताएं:** Windows 10 या 11, PowerShell 5.1+, Administrator अनुमतियां।

### इंस्टॉल करें (पहली बार)

**Administrator** के रूप में PowerShell खोलें और चलाएं:

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex
```

### ऑफसेट अपडेट करें (Windows अपडेट के बाद)

```powershell
irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex
```

### इंस्टॉलेशन सत्यापित करें

`C:\Program Files\RDP Wrapper\RDPConf.exe` खोलें। आपको दिखना चाहिए:

- **Wrapper state:** Installed
- **Service state:** Running
- **Listener state:** Listening

---

## श्रेय

- **[stascorp](https://github.com/stascorp/rdpwrap)** — मूल RDP Wrapper अवधारणा
- **[llccd](https://github.com/llccd/RDPWrapOffsetFinder)** — RDPWrapOffsetFinder टूल
- **[sebaxakerhtc](https://github.com/sebaxakerhtc/rdpwrap.ini)** — समुदाय INI रिपॉजिटरी

---

## अस्वीकरण

यह प्रोजेक्ट केवल **शैक्षिक और अनुसंधान उद्देश्यों** के लिए है। RDP Wrapper का उपयोग Microsoft के Windows लाइसेंसिंग शर्तों का उल्लंघन कर सकता है। लेखक किसी भी जिम्मेदारी से इनकार करते हैं। अपने जोखिम पर उपयोग करें।
