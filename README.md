# Flutter Starter Kit 🚀

A production-ready **Flutter base project** engineered as a clean, scalable starting point for any new app. It ships with a solid architecture, networking layer, state management, localization, theming, and a rich set of reusable utilities — so you can skip the boilerplate and start building features on day one.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart SDK](https://img.shields.io/badge/Dart-%5E3.6.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-flutter__bloc-8A2BE2)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ Features

- 🏗️ **Feature-based architecture** — organized, scalable folder structure that grows cleanly with your app.
- 🌐 **Networking layer** — `dio` with a configurable API manager, interceptors, and centralized error handling.
- 🧠 **State management** — `flutter_bloc` + `equatable`, with a custom `BlocObserver` for debugging.
- 💉 **Dependency Injection** — `get_it` service locator wired at startup.
- 🧩 **Functional error handling** — `dartz` (`Either`) with a reusable `UseCase` contract and `Failure` types.
- 🌍 **Localization** — English/Arabic out of the box (`en.json` / `ar.json`) with a runtime locale switcher (`LocaleCubit`).
- 🎨 **Theming** — centralized colors, text styles, and Material theme with `google_fonts`.
- 📱 **Responsive UI** — `flutter_screenutil` for pixel-perfect scaling across devices.
- 📶 **Connectivity awareness** — live internet status via `connectivity_plus` + `internet_connection_checker`.
- 💾 **Local storage** — typed `PreferencesManager` wrapper over `shared_preferences`.
- 🧱 **Reusable widgets & utilities** — base screens, loaders, empty/no-data states, custom form fields, validators, formatters (date/number), extensions, and feedback (snackbars/toasts).

---

## 🛠️ Tech Stack

| Concern | Package |
|---|---|
| State Management | `flutter_bloc`, `equatable` |
| Networking | `dio` |
| Dependency Injection | `get_it` |
| Functional / Errors | `dartz` |
| Responsive UI | `flutter_screenutil` |
| Fonts | `google_fonts` |
| Localization | `flutter_localizations`, `intl` |
| Local Storage | `shared_preferences` |
| Connectivity | `connectivity_plus`, `internet_connection_checker` |
| Misc | `package_info_plus`, `fluttertoast`, `keyboard_dismisser` |

---

## 📂 Project Structure

```
lib/
├── apis/                # Networking layer
│   ├── _base/           # DioApiManager (core HTTP client)
│   ├── errors/          # API error models & helpers
│   ├── interceptor/     # Request/response interceptors
│   └── api_keys.dart    # Endpoint/key constants
├── core/                # Framework-level building blocks
│   ├── widgets/         # Base stateless/stateful screen widgets
│   ├── usecase.dart     # UseCase contract
│   ├── failures.dart    # Failure types
│   └── ...              # Theming, pagination, platform, screen sizing
├── feature/             # App features (each self-contained)
│   ├── home/
│   └── on_boarding/
├── preferences/         # Local storage manager & keys
├── res/                 # Colors, text styles, asset paths, icons
├── utils/               # Cross-cutting utilities
│   ├── bloc_observer/   # App-wide Bloc logging
│   ├── connectivity/    # Connectivity listener
│   ├── extensions/      # Dart/Flutter extensions
│   ├── feedback/        # Snackbars & toasts
│   ├── format/          # Date & number formatting
│   ├── loaders/         # Loading widgets
│   ├── locale/          # Localization engine & cubit
│   ├── validations/     # Form validators
│   └── widgets/         # Shared reusable widgets
├── app.dart             # Root MaterialApp
└── main.dart            # Entry point & DI bootstrap

locale/                  # en.json / ar.json translation files
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Dart `^3.6.2`)
- An IDE (VS Code / Android Studio) with the Flutter plugin

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Youssef-Eltohamy/flutter_starter_kit.git
cd flutter_starter_kit

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> 💡 **Using this as a base for a new project?** Update the package name in `pubspec.yaml`, the app id under `android/` and `ios/`, then replace the sample `feature/` modules with your own.

---

## 🌍 Localization

Translations live in the `locale/` folder (`en.json`, `ar.json`). The active language is managed by `LocaleCubit` and can be switched at runtime. To add a new key, add it to both JSON files and reference it via the localization helper.

---

## 🤝 Contributing

This is a personal base/starter project, but suggestions and improvements are welcome. Feel free to open an issue or a pull request.

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.
