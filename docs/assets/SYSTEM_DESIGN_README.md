# Sila App - System Design Documentation

## Overview

This directory contains the complete system design documentation for **Sila (صلة)**, a production-grade Islamic devotion platform built with Flutter.

---

## 📁 Design Assets

| File | Description | Format |
|------|-------------|--------|
| `SYSTEM_ARCHITECTURE.svg` | Full system architecture diagram | SVG |
| `USER_JOURNEY.svg` | User journey & feature flow | SVG |
| `system_design.html` | Interactive HTML design sheet | HTML |
| `system_design.png` | UI mockup (generate with prompts) | PNG |

---

## 📐 System Architecture

**File:** `SYSTEM_ARCHITECTURE.svg`

The architecture follows a **Feature-First** design with strict layer separation:

### Layers

| Layer | Components | Purpose |
|-------|------------|---------|
| **Presentation** | Quran, Prayer, Azkar, Hifz modules | UI screens & widgets |
| **State Management** | Riverpod Providers | Reactive state & logic |
| **Domain** | Entities & Use Cases | Business rules & models |
| **Data** | Repositories | Data access abstraction |
| **Infrastructure** | Services | Audio, Location, STT, Notifications |

### Key Design Decisions

- **Local-First**: All core functionality works offline
- **Isar DB**: Embedded NoSQL for blazing-fast local storage
- **Riverpod Codegen**: Compile-safe, zero-boilerplate state management
- **Feature Isolation**: Each module can be developed independently

---

## 🔄 User Journey & Feature Flow

**File:** `USER_JOURNEY.svg`

### Daily Worship Journey

```
App Launch → Prayer Times → Morning Azkar → Quran Reading → Hifz Session
     ↑                                                              ↓
     └──────────────── Evening Azkar ←──────────────────────────────┘
```

### Feature Flows

| Feature | Flow | Offline Support |
|---------|------|-----------------|
| **Quran Reader** | Select Surah → View Verses → Play Audio | Full Mushaf + cached audio |
| **Prayer Times** | Get Location → Calculate → Notify | Algorithm-based calculation |
| **Azkar Tracker** | Select Category → Count → Track Progress | JSON assets + Isar |
| **Hifz Memorization** | Listen → Shadow → Test | On-device STT |

---

## 🎨 UI Design Specifications

### Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Navy Dark | `#0A0F1E` | Primary background |
| Navy Medium | `#1A2340` | Card backgrounds |
| Navy Light | `#0F1729` | Secondary backgrounds |
| Gold Warm | `#C9A84C` | Accents, highlights, progress |
| Cream Soft | `#F5F0E6` | Text, icons |

### Typography

| Element | Font | Weight |
|---------|------|--------|
| Arabic Text | Amiri, Noto Naskh Arabic | 400-700 |
| UI Text | System sans-serif | 400-600 |
| Monospace | Monospace | 400 |

### Design Elements

- **Cards**: 16-20px border radius
- **Glow Effects**: Subtle gold glow on active elements
- **Progress Rings**: Circular progress with gold accent
- **Geometric Patterns**: Faint Islamic pattern watermark

---

## 🔧 Technical Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State | Riverpod (Codegen) |
| Database | Isar |
| Audio | just_audio + audioplayers |
| Speech | speech_to_text (on-device) |
| Notifications | flutter_local_notifications |
| Localization | Flutter Intl (ARB) |
| Platforms | Android, iOS |

---

## 📊 Data Models

### Quran Module
- `Surah` - Chapter data
- `Verse` - Individual ayah with metadata
- `Bookmark` - User-saved positions
- `Reciter` - Audio reciter profiles

### Prayer Module
- `PrayerTime` - Daily schedule
- `Location` - GPS coordinates
- `Adhan` - Audio notification settings
- `QiblaDirection` - Compass bearing

### Azkar Module
- `Dhikr` - Individual dhikr text & count
- `Category` - Morning/Evening/Situational
- `Progress` - Completion tracking
- `WirdEntry` - Daily routine item

### Hifz Module
- `MemorizedSurah` - Surah progress
- `Ayah` - Individual verse status
- `ReviewSession` - Practice session data
- `Goal` - Daily/weekly targets

---

## 📱 Screen Flow

```
┌─────────────────────────────────────────────────────────┐
│                      HOME SCREEN                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  │
│  │  Quran   │  │  Prayer  │  │  Azkar   │  │  Hifz  │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └───┬────┘  │
│       │             │             │             │        │
│  ┌────▼─────┐  ┌────▼─────┐  ┌────▼─────┐  ┌───▼────┐  │
│  │ Surah    │  │ Times    │  │ Category │  │ Listen │  │
│  │ List     │  │ View     │  │ Select   │  │ Screen │  │
│  └────┬─────┘  └──────────┘  └────┬─────┘  └───┬────┘  │
│       │                           │             │        │
│  ┌────▼─────┐                ┌────▼─────┐  ┌───▼────┐  │
│  │ Reader   │                │ Counter  │  │ Shadow │  │
│  │ Screen   │                │ Screen   │  │ Mode   │  │
│  └────┬─────┘                └──────────┘  └───┬────┘  │
│       │                                        │        │
│  ┌────▼─────┐                            ┌─────▼────┐  │
│  │ Audio    │                            │ Test     │  │
│  │ Player   │                            │ Screen   │  │
│  └──────────┘                            └──────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 🚀 Implementation Phases

### Phase 1: Core Foundation
- [x] Project structure setup
- [x] Riverpod configuration
- [x] Isar database integration
- [x] Localization framework

### Phase 2: Feature Modules
- [x] Quran reader with audio
- [x] Prayer times calculation
- [x] Azkar tracker
- [x] Hifz memorization system

### Phase 3: Polish & Production
- [x] UI/UX refinement
- [x] Performance optimization
- [x] Offline functionality
- [x] Release preparation

---

## 📄 Related Documentation

| Document | Location |
|----------|----------|
| Implementation Report | `docs/IMPLEMENTATION_REPORT.md` |
| Hifz Feature Audit | `docs/hifz_feature_report.md` |
| Localization Guide | `docs/HOW_LOCALIZATION_WORKS.md` |
| Best Practices | `docs/BEST_PRACTICES_GUIDE.md` |

---

## 📞 Contact

For questions about the system design, please open an issue on GitHub or contact the development team.

---

Built with care for the Ummah · صُنع بإخلاص لهذه الأمة
