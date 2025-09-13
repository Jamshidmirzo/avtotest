# 📱 Flutter Driver testing app

This project uses a modular command structure. Each file contains specific commands for different development phases:

------------------------------------------------------------------------

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://gitlab.com/ravshanyusupov/avtotest.git
```

# Get dependencies
```bash
flutter pub get
```

# Generate generation files
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# Generate string local keys
```bash
dart lib/core/scripts/generate_strings_script.dart
```

------------------------------------------------------------------------

# Customize splash screen
# Get dependencies
# Create logo for using by default platform (Android/iOS) splash screens

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

## 🎯 Architecture

### State Management Pattern
- **BaseState**: Generic state wrapper
- **BaseCubit**: Abstract cubit with common functionality
- **BaseListener**: Event handling wrapper
- **BaseBuilder**: State-based widget builder
- **BasePage**: Complete page structure

## 📚 Documentation

- **[🛠️ All Commands](COMMANDS.md)** - Complete command reference
- Development, build, maintenance, and git commands


------------------------------------------------------------------------

## 🆘 Troubleshooting

### Build Issues
```bash
flutter clean
rm -rf .dart_tool/ build/ pubspec.lock
flutter pub get
flutter run --no-hot
```

### Code Generation Issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```


## rasmlarni to'girlash

```bash
find assets/content/media -name "*.JPG" -exec bash -c 'mv "$0" "${0%.JPG}.jpg"' {} \;
flutter clean
flutter pub get
flutter run
```

------------------------------------------------------------------------

## 🌍 Localization

The app supports multiple languages:
- 🇺🇿 Uzbek (Latin)
- 🇬🇧 English
- 🇷🇺 Russian

Translation files are auto-generated from JSON files in `assets/translations/`.


------------------------------------------------------------------------

## 🚀 Deployment

### Android
```bash
flutter build appbundle --release    # Play Store
flutter build apk --release          # Direct distribution
```

### iOS
```bash
flutter build ios --release          # App Store
```

------------------------------------------------------------------------

**For detailed commands and troubleshooting, see [COMMANDS.md](COMMANDS.md)**