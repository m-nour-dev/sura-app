<div align="center">

<br/>

<img src="assets/images/app_logo.png" width="110" height="110" alt="Sila Logo"/>

<br/>

# صلة · Sila

### A production-grade Islamic devotion platform built with Flutter

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Version](https://img.shields.io/badge/Version-v4.0.0-22C55E?style=flat-square)](https://github.com/7amed3li/Sila/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-F59E0B?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-6366F1?style=flat-square)](https://flutter.dev/multi-platform)
[![Languages](https://img.shields.io/badge/Languages-Arabic%20%7C%20Turkish-EF4444?style=flat-square)](#localization)

<br/>

[Features](#features) · [Architecture](#architecture) · [Tech Stack](#tech-stack) · [Getting Started](#getting-started) · [Documentation](#documentation)

<br/>

---

</div>

## Overview

**Sila (صلة)** is a production-ready Islamic devotion platform engineered with Flutter. It consolidates four core pillars of daily worship — Quran, Prayer, Azkar, and AI-assisted Hifz — into a single, cohesive, and performant experience.

The app is designed with a local-first philosophy: all core functionality works fully offline, with cloud features treated as progressive enhancements. It is currently live and serving a growing user base.

> **صلة** هو تطبيق إسلامي للعبادة اليومية مبني بـ Flutter ومطلق فعلياً على متاجر التطبيقات. يجمع التطبيق بين القرآن الكريم، مواقيت الصلاة، الأذكار، ومنظومة الحفظ الذكي في تجربة واحدة متكاملة تعمل بالكامل دون اتصال.

---

## Features

### 📖 Quran Reader
- High-fidelity Mushaf rendering with per-verse audio playback
- Reciter library with local audio cache management for full offline use
- Customizable typography — font family, size, line spacing, and reading mode
- Bookmarks, last-read position persistence, and verse-level navigation

### 🧠 Smart Hifz & Tasmi' (AI-Powered)
- Real-time recitation evaluation using on-device Speech-to-Text
- Smart normalization engine handles diacritics, hamza variants, and common pronunciation patterns
- Multi-stage learning flow: **Listen → Shadow → Test**
- Personalized daily Hifz goals with long-term performance tracking and progress roadmap

### 🕌 Prayer Times & Adhan
- Accurate prayer time calculation supporting all major juristic methods
- Location-aware scheduling with automatic DST handling
- Per-prayer Adhan customization — preview and set from a library of recordings
- Reliable notification system with qibla direction

### 📿 Azkar & Wird
- Complete morning, evening, and situational adhkar collections
- Visual progress tracking with interactive counters and daily completion rings
- Wird planner with contextual reminders tied to your prayer schedule

<br/>

---

## Architecture

The project follows a **Feature-First** architecture with strict layer separation, designed to scale across a large team.

```
sila_app/lib/
│
├── core/                        # Shared infrastructure
│   ├── constants/               # App-wide constants & config
│   ├── extensions/              # Dart/Flutter extensions
│   ├── theme/                   # Design system (colors, typography, spacing)
│   └── utils/                   # Helpers and utilities
│
├── features/                    # Isolated feature modules
│   ├── quran/                   # Quran reader, audio, bookmarks
│   │   ├── data/                # Repositories & data sources
│   │   ├── domain/              # Entities, use-cases
│   │   └── presentation/        # UI + Riverpod providers
│   │
│   ├── hifz/                    # Smart memorization system
│   ├── prayer/                  # Prayer times & Adhan
│   └── azkar/                   # Dhikr & Wird tracking
│
└── shared/                      # Cross-feature widgets & providers
```

**Key architectural decisions:**
- **Riverpod (Codegen)** for reactive, compile-safe state management with zero boilerplate
- **Isar** as the primary database — blazing-fast, embedded NoSQL, fully async
- **Local-first**: all critical data lives on-device; network calls are isolated behind repository interfaces
- **Feature isolation**: each feature can be developed, tested, and reviewed independently

<br/>

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Framework | Flutter 3.x | Cross-platform UI |
| Language | Dart 3.x | Null-safe, compiled |
| State | Riverpod (Codegen) | Reactive, compile-safe |
| Database | Isar | Local-first NoSQL |
| Audio | just_audio + audioplayers | Quran & Adhan playback |
| Speech | speech_to_text | On-device STT for Hifz |
| Notifications | flutter_local_notifications | Prayer & Wird reminders |
| Localization | Flutter Intl (ARB) | Arabic, Turkish |

<br/>

---

## Getting Started

### Prerequisites

| Tool | Minimum Version |
|---|---|
| Flutter SDK | 3.19.x |
| Dart SDK | 3.3.x |
| Android SDK | API 21+ |
| Xcode (iOS) | 14.x |

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/7amed3li/Sila.git
cd Sila/sila_app

# 2. Install dependencies
flutter pub get

# 3. Run code generation (Riverpod + Isar)
dart run build_runner build --delete-conflicting-outputs

# 4. Run on a connected device or emulator
flutter run

# Run in release mode
flutter run --release
```

### Build for Production

```bash
# Android APK
flutter build apk --release --target-platform android-arm64

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ipa --release
```

<br/>

---

## Localization

The app ships with full **Arabic** and **Turkish** support, with Arabic as the primary RTL language.

Localization files are maintained under `sila_app/lib/l10n/` in ARB format. To add or update translations:

```bash
flutter gen-l10n
```

See [`docs/HOW_LOCALIZATION_WORKS.md`](docs/HOW_LOCALIZATION_WORKS.md) for the full localization strategy and contribution guidelines.

<br/>

---

## Repository Structure

```
.
├── docs/                        # Technical documentation & audit reports
│   ├── hifz_feature_report.md
│   ├── HOW_LOCALIZATION_WORKS.md
│   └── IMPLEMENTATION_REPORT.md
│
├── sila_app/                    # Flutter application root
│   ├── lib/                     # Application source code
│   ├── assets/                  # Fonts, audio, static data
│   └── scripts/                 # Local automation scripts
│
├── LICENSE
└── README.md
```

<br/>

---

## Documentation

| Document | Description |
|---|---|
| [Hifz Feature Audit](docs/hifz_feature_report.md) | Deep-dive into the AI memorization system design |
| [Localization Strategy](docs/HOW_LOCALIZATION_WORKS.md) | RTL/LTR handling, ARB workflow, contributor guide |
| [Implementation Report](docs/IMPLEMENTATION_REPORT.md) | Performance benchmarks and architecture decisions |

<br/>

---

## Contributing

Contributions are welcome. Please open an issue before submitting a pull request to discuss the proposed change. All PRs should target the `develop` branch.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/)
4. Open a Pull Request against `develop`

<br/>

---

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for full terms.

<br/>

---

## Dedication · إهداء

<div align="center">

*هذا العمل وقف لله تعالى وصدقة جارية.*

</div>

تُهدى ثمرة هذا المشروع إلى أرواح من أحببناهم وفارقونا:

- **محمود أحمد وهبة** — صديقي وأخي، رحمه الله
- **الدكتور محمود أحمد فرحات** — صديقي وأخي، رحمه الله
- **عبدالرحمن جمال** — صديقي وأخي، رحمه الله
- خالي، وجدي، وجدتي — غفر الله لهم جميعاً
- وكل مسلم انقطع عمله ولا يجد من يدعو له

اللهم اجعل هذا العمل نوراً وبشرى لهم في قبورهم، وثقّل به موازينهم، واجمعنا بهم في مستقر رحمتك. آمين.

<br/>

<div align="center">

---

Built with care for the Ummah · صُنع بإخلاص لهذه الأمة

</div>
