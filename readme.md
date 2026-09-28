# Aplikasi Booking Service Kendaraan

> Technical & UI/UX Assessment — Mobile Application Development (Flutter) & Product Interface Design **ServisinAja**

A Flutter mobile application for booking motorcycle service appointments, featuring vehicle management (garage), service selection, schedule booking, live tracking, and booking history.

---

## ✨ Features

- **Home Screen** — Active booking overview and quick access to services
- **Garage** — Manage personal vehicles (add, edit, delete, set main vehicle)
- **Book Service** — Multi-step booking flow:
  - Vehicle selection (single or multi-vehicle)
  - Service & spare part selection per vehicle
  - Schedule & pit assignment
  - Booking review with dynamic discount logic
- **Live Tracking** — Real-time status tracking per vehicle/pit with filter tabs
- **Activity History** — Past and active bookings with detail view
- **Book Confirm** — Booking confirmation with booking code

---

## 🛠 SDK & Environment Requirements

| Tool            | Version                   |
| --------------- | ------------------------- |
| **Flutter**     | `3.44.7` (stable channel) |
| **Dart SDK**    | `^3.12.2`                 |
| **Android SDK** | `36.0.0`                  |
| **Java (JDK)**  | `21.0.12` (LTS)           |

> Tested on **Ubuntu 26.04 LTS**. Should work on macOS and Windows with Flutter properly installed.

---

## 📦 Dependencies

### Runtime

| Package                                                             | Version   | Purpose                                                  |
| ------------------------------------------------------------------- | --------- | -------------------------------------------------------- |
| [`get`](https://pub.dev/packages/get)                               | `^4.7.3`  | State management, routing, dependency injection (GetX)   |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.5.5`  | Local persistent storage (JSON data, bookings, vehicles) |
| [`intl`](https://pub.dev/packages/intl)                             | `^0.20.3` | Date/time formatting and currency (Rupiah) formatting    |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)       | `^1.0.8`  | iOS-style icon set                                       |

### Dev

| Package                                                   | Version  | Purpose                 |
| --------------------------------------------------------- | -------- | ----------------------- |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) | `^6.0.0` | Recommended lint rules  |
| `flutter_test`                                            | bundled  | Unit and widget testing |

---

## 📁 Project Structure

```
lib/
├── app/
│   ├── components/         # Shared/reusable widgets
│   ├── const/              # App-wide constants (colors, etc.)
│   ├── modules/            # Feature modules (GetX pattern)
│   │   ├── homeScreen/
│   │   ├── garageScreen/
│   │   ├── bookScreen/
│   │   ├── bookVehicle/
│   │   ├── bookService/
│   │   ├── bookSchedule/
│   │   ├── bookReview/
│   │   ├── bookConfirm/
│   │   ├── liveTracking/
│   │   ├── activityScreen/
│   │   └── serviceScreen/
│   ├── routes/             # App routes (GetX routing)
│   └── services/           # StorageService, SnackbarService, Formatter
└── main.dart

assets/
├── json/
│   └── dummyData.json      # Seed data (users, vehicles, services, workshops, etc.)
└── images/
    └── icon.png
```

---

## 🚀 Running Locally

### 1. Prerequisites

Make sure you have the following installed:

- [Flutter SDK 3.44.7+](https://docs.flutter.dev/get-started/install)
- Android Studio / VS Code with Flutter plugin
- An Android emulator or physical device (API 21+), or Chrome for web

Verify your setup:

```bash
flutter doctor
```

All checkmarks should be green before proceeding.

---

### 2. Clone the Repository

```bash
git clone <repository-url>
cd project
```

---

### 3. Install Dependencies

```bash
flutter pub get
```

---

### 4. Run the App

**Android (emulator or device):**

```bash
flutter run
```

**Specific device:**

```bash
flutter devices                  # List connected devices
flutter run -d <device-id>
```

**Web (Chrome):**

```bash
flutter run -d chrome
```

**Debug mode with verbose logs:**

```bash
flutter run --debug
```

---

### 5. Build Release APK (optional)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📊 Assets & Data

The app uses **`assets/json/dummyData.json`** as its seed data source, loaded into `SharedPreferences` on first launch via `StorageService`. It contains:

| Key               | Description                                                               |
| ----------------- | ------------------------------------------------------------------------- |
| `users`           | App user accounts                                                         |
| `vehicles`        | Default garage vehicles                                                   |
| `brand` / `model` | Motorcycle brands and models (models filtered by `brandId`)               |
| `services`        | Service packages (Servis Berkala, Ganti Oli, Servis CVT, Tune Up Injeksi) |
| `spareParts`      | Spare parts catalog                                                       |
| `symptoms`        | Common symptoms checklist                                                 |
| `workshops`       | Available workshop locations with pit capacity                            |
| `activities`      | Booking history (starts empty, populated on each booking)                 |

> All data is stored locally using `SharedPreferences`. **No backend or internet connection is required** to run the app.
