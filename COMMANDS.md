# 🛠️ Flutter Commands Reference

## 🚀 Quick Start

# Get dependencies
# Generate generation files
# Generate string local keys

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
dart lib/core/scripts/generate_strings_script.dart
```

------------------------------------------------------------------------

### Code Generation

# ⚙️ Runs code generation (freezed, json_serializable, etc.)
# Run after editing model classes or adding annotations like @freezed or @JsonSerializable.
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# 🔤 Generates localized string accessors from .json files
# Run this after editing translation files in assets/localization.
```bash
dart lib/core/scripts/generate_strings_script.dart
```

------------------------------------------------------------------------


## 🆘 Quick Fix for Build Issues
```bash
flutter clean
rm -rf .dart_tool/
rm -rf build/
rm pubspec.lock
flutter pub get
flutter run --no-hot
```

```bash
flutter clean
flutter pub get
flutter run --no-hot
```

## Cold Run (when hot reload fails)
```bash
flutter run --no-hot
```

------------------------------------------------------------------------

## 🧹 Maintenance Commands

### Clean & Reset

# Clean build artifacts
```bash
flutter clean                        
```

# Get dependencies
```bash
flutter pub get                      
```

# Repair package cache
```bash
flutter pub cache repair             
```

# Download Flutter binaries
```bash
flutter precache                     
```

### Complete Reset (when build fails)
```bash
rm -rf .dart_tool build pubspec.lock
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart lib/core/scripts/generate_strings_script.dart
```

------------------------------------------------------------------------

## ▶️ Development Commands

### Run App

# Default device
```bash
flutter run
```

# Specific device
```bash
flutter run -d <deviceId>
```

# iOS device/simulator
```bash
flutter run -d ios
```

# Release mode
```bash
flutter run --release
```

# Disable hot reload
```bash
flutter run --no-hot
```

## 🏗️ Build Commands

### Android

# Split APK by architecture
```bash
flutter build apk --split-per-abi    
```

# App Bundle for Play Store
```bash
flutter build appbundle --release    
```

# Universal APK
```bash
flutter build apk --release          
```

### iOS

# iOS without signing
```bash
flutter build ios --no-codesign      
```

# iOS with signing
```bash
flutter build ios --release          
```

------------------------------------------------------------------------

## 📱 Git Commit Guide

### Format
```
<type>: <description>
```

### Types
- `feat` - New feature
- `fix` - Bug fix  
- `refactor` - Code improvement
- `style` - Formatting
- `test` - Add/update tests
- `docs` - Documentation
- `chore` - Dependencies, build tools

### Examples
```bash
✅ feat: add user login
✅ fix: resolve crash on startup
✅ refactor: simplify auth logic
✅ style: fix indentation
✅ test: add login validation tests
✅ docs: update README
✅ chore: upgrade dependencies
```

### Rules
- Use imperative mood ("add", not "added")
- Start with lowercase
- Keep under 50 characters
- Be specific, not generic