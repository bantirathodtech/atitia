# 🛠️ Flutter Automation Toolkit

Universal automation toolkit for Flutter app development, builds, signing, testing, releases, and CI/CD — supporting Android, iOS, macOS, and Web.

## 📁 Directory Structure

```
atitia/
├── .secrets/                    # 🔐 All secrets (gitignored)
│   ├── android/
│   │   ├── keystore.jks
│   │   ├── keystore.properties
│   │   ├── service_account.json
│   │   └── gradle.properties
│   ├── ios/
│   │   ├── Certificates.p12
│   │   ├── ProvisionProfile.mobileprovision
│   │   ├── AppStoreConnect_APIKey.p8
│   │   └── exportOptions.plist
│   ├── macos/
│   │   ├── Certificates.p12
│   │   ├── ProvisionProfile.provisionprofile
│   │   └── exportOptions.plist
│   └── common/
│       ├── .env                 # Environment variables
│       └── firebase_options.dart
│
├── scripts/                     # 🛠️ Automation scripts
│   ├── setup_env.sh            # Environment setup
│   ├── flutter_clean.sh        # Clean all platforms
│   ├── flutter_build.sh        # Build for platforms
│   ├── android_sign.sh          # Android signing
│   ├── ios_sign.sh              # iOS signing
│   ├── release_android.sh       # Android release build
│   ├── release_ios.sh           # iOS release build
│   ├── build_web.sh             # Web build & deploy
│   ├── deploy_playstore.sh      # Play Store deployment
│   ├── deploy_appstore.sh       # App Store deployment
│   ├── test_runner.sh           # Test execution
│   ├── version_bump.sh           # Version management
│   ├── generate_localization.sh # Localization
│   ├── generate_icons.sh        # Icon generation
│   ├── firebase_setup.sh         # Firebase config
│   ├── git_hooks.sh              # Git hooks
│   ├── setup_cicd.sh             # CI/CD setup
│   ├── diagnostics.sh            # Environment diagnostics
│   ├── release_all.sh            # Full release workflow
│   └── cli.sh                    # CLI wrapper
│
└── pubspec.yaml
```

## 🚀 Quick Start

### 1. Initial Setup

```bash
# Create .env file from template
cp .secrets/common/.env.example .secrets/common/.env
# Edit with your values
nano .secrets/common/.env

# Setup environment
bash scripts/setup_env.sh

# Run diagnostics
bash scripts/diagnostics.sh
```

### 2. Configure Signing

**Android:**
```bash
# Generate keystore (first time only)
bash scripts/android_sign.sh generate

# Configure signing
bash scripts/android_sign.sh configure

# Verify setup
bash scripts/android_sign.sh verify
```

**iOS:**
```bash
# Setup signing (import certificates)
bash scripts/ios_sign.sh setup

# Verify setup
bash scripts/ios_sign.sh verify
```

### 3. Build & Release

```bash
# Build for all platforms
bash scripts/flutter_build.sh

# Release Android
bash scripts/release_android.sh both

# Release iOS
bash scripts/release_ios.sh

# Release Web
bash scripts/build_web.sh

# Or use the master script
bash scripts/release_all.sh
```

### 4. Deploy

```bash
# Deploy to Play Store
bash scripts/deploy_playstore.sh internal

# Deploy to App Store
bash scripts/deploy_appstore.sh

# Deploy Web to Firebase Hosting
bash scripts/build_web.sh yes
```

## 🎯 CLI Usage

Use the unified CLI wrapper:

```bash
# Show help
bash scripts/cli.sh help

# Setup and verify
bash scripts/cli.sh setup
bash scripts/cli.sh diagnose

# Build
bash scripts/cli.sh build android
bash scripts/cli.sh build ios
bash scripts/cli.sh build all

# Test
bash scripts/cli.sh test unit
bash scripts/cli.sh test all

# Release
bash scripts/cli.sh release android
bash scripts/cli.sh release all

# Deploy
bash scripts/cli.sh deploy playstore
bash scripts/cli.sh deploy appstore
bash scripts/cli.sh deploy all

# Version management
bash scripts/cli.sh version patch
bash scripts/cli.sh version build

# Utilities
bash scripts/cli.sh icons
bash scripts/cli.sh localize
bash scripts/cli.sh firebase all
bash scripts/cli.sh hooks install
```

## 📋 Script Reference

### Core Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `setup_env.sh` | Load environment variables | `source scripts/setup_env.sh` |
| `flutter_clean.sh` | Clean all build artifacts | `bash scripts/flutter_clean.sh` |
| `flutter_build.sh` | Build for platforms | `bash scripts/flutter_build.sh android release` |
| `diagnostics.sh` | Verify environment | `bash scripts/diagnostics.sh` |

### Signing Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `android_sign.sh` | Android signing setup | `bash scripts/android_sign.sh configure` |
| `ios_sign.sh` | iOS signing setup | `bash scripts/ios_sign.sh setup` |

### Release Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `release_android.sh` | Android release build | `bash scripts/release_android.sh both` |
| `release_ios.sh` | iOS release build | `bash scripts/release_ios.sh` |
| `build_web.sh` | Web build & deploy | `bash scripts/build_web.sh yes` |
| `release_all.sh` | Full release workflow | `bash scripts/release_all.sh yes` |

### Deployment Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `deploy_playstore.sh` | Play Store upload | `bash scripts/deploy_playstore.sh internal` |
| `deploy_appstore.sh` | App Store upload | `bash scripts/deploy_appstore.sh` |

### Development Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `test_runner.sh` | Run tests | `bash scripts/test_runner.sh all yes` |
| `version_bump.sh` | Bump version | `bash scripts/version_bump.sh patch` |
| `generate_localization.sh` | Generate l10n | `bash scripts/generate_localization.sh` |
| `generate_icons.sh` | Generate icons | `bash scripts/generate_icons.sh` |
| `firebase_setup.sh` | Firebase config | `bash scripts/firebase_setup.sh all` |
| `git_hooks.sh` | Git hooks | `bash scripts/git_hooks.sh install` |

## 🔐 Secrets Management

All secrets are stored in `.secrets/` directory (gitignored):

### Required Files

**Android:**
- `keystore.jks` - Production signing keystore
- `keystore.properties` - Keystore configuration
- `service_account.json` - Play Console API key

**iOS:**
- `Certificates.p12` - Distribution certificate
- `ProvisionProfile.mobileprovision` - Provisioning profile
- `AppStoreConnect_APIKey.p8` - App Store Connect API key
- `exportOptions.plist` - Export options

**Common:**
- `.env` - Environment variables (API keys, tokens, URLs)

### Environment Variables

Create `.secrets/common/.env` with:

```bash
# Project
PROJECT_ROOT="/path/to/atitia"
APP_NAME="Atitia"
APP_BUNDLE_ID="com.avishio.atitia"

# Android
ANDROID_KEYSTORE_PATH="$PROJECT_ROOT/.secrets/android/keystore.jks"
ANDROID_KEYSTORE_PASSWORD="your_password"
ANDROID_KEY_ALIAS="atitia-release"
ANDROID_KEY_PASSWORD="your_password"

# iOS
IOS_CERT_PATH="$PROJECT_ROOT/.secrets/ios/Certificates.p12"
IOS_CERT_PASSWORD="your_password"
IOS_PROVISION_PROFILE="$PROJECT_ROOT/.secrets/ios/ProvisionProfile.mobileprovision"

# Firebase
FIREBASE_PROJECT_ID="atitia-87925"
```

## 🔄 Complete Workflow Example

```bash
# 1. Setup
bash scripts/cli.sh setup

# 2. Bump version
bash scripts/cli.sh version patch

# 3. Run tests
bash scripts/cli.sh test all

# 4. Build releases
bash scripts/cli.sh release all

# 5. Deploy
bash scripts/cli.sh deploy all
```

## 🧪 Testing

```bash
# Run all tests with coverage
bash scripts/test_runner.sh all yes

# Run specific test type
bash scripts/test_runner.sh unit yes
bash scripts/test_runner.sh widget yes
bash scripts/test_runner.sh integration yes
```

## 📈 Version Management

```bash
# Bump build number
bash scripts/version_bump.sh build

# Bump patch version (1.0.0 -> 1.0.1)
bash scripts/version_bump.sh patch

# Bump minor version (1.0.0 -> 1.1.0)
bash scripts/version_bump.sh minor

# Bump major version (1.0.0 -> 2.0.0)
bash scripts/version_bump.sh major

# Set custom version
bash scripts/version_bump.sh custom "1.2.3+5"
```

## 🔥 Firebase Setup

```bash
# Setup Firebase for all platforms
bash scripts/firebase_setup.sh all

# Or specific platform
bash scripts/firebase_setup.sh android
bash scripts/firebase_setup.sh ios
bash scripts/firebase_setup.sh web
```

## 🎨 Icon & Localization

```bash
# Generate app icons
bash scripts/generate_icons.sh assets/app_icon.jpeg

# Generate localization files
bash scripts/generate_localization.sh
```

## 🔍 Diagnostics

Run comprehensive diagnostics:

```bash
bash scripts/diagnostics.sh
```

Checks:
- ✅ Flutter/Dart SDK installation
- ✅ Android SDK and tools
- ✅ iOS/macOS tools (on macOS)
- ✅ Firebase configuration
- ✅ Signing setup
- ✅ Secrets availability
- ✅ Project structure

## 🪝 Git Hooks

Install pre-commit hooks:

```bash
# Install hooks
bash scripts/git_hooks.sh install

# Uninstall hooks
bash scripts/git_hooks.sh uninstall
```

Hooks automatically:
- Format code (`dart format`)
- Analyze code (`flutter analyze`)
- Run tests (optional)

## 🔄 CI/CD Integration

### GitHub Actions

Scripts are designed to work with GitHub Actions. Use secrets from repository settings:

```yaml
- name: Setup Android Signing
  run: bash scripts/android_sign.sh configure
  env:
    ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
```

### Codemagic

Use environment variables in `codemagic.yaml`:

```yaml
environment:
  groups:
    - app_secrets
scripts:
  - bash scripts/release_android.sh
```

## 🛠️ Requirements

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / Android SDK
- Xcode (for iOS/macOS)
- CocoaPods (for iOS/macOS)
- Node.js (for web/Firebase)
- Firebase CLI (optional, for web deployment)
- Fastlane (optional, for store deployment)

## 🔒 Security Best Practices

1. **Never commit `.secrets/` directory**
2. **Use CI/CD secrets** for automated builds
3. **Rotate credentials** regularly
4. **Limit access** to team members who need deployment permissions
5. **Backup securely** using encrypted storage (GPG, age, cloud key management)

## 📚 Additional Resources

- [Scripts README](scripts/README.md)
- [Secrets README](.secrets/README.md)
- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)

## 🐛 Troubleshooting

### Common Issues

**Signing errors:**
```bash
# Verify Android signing
bash scripts/android_sign.sh verify

# Verify iOS signing
bash scripts/ios_sign.sh verify
```

**Build failures:**
```bash
# Clean everything
bash scripts/flutter_clean.sh

# Rebuild
bash scripts/flutter_build.sh
```

**Missing secrets:**
```bash
# Run diagnostics
bash scripts/diagnostics.sh

# Check .secrets directory structure
ls -la .secrets/
```

## 📝 Notes

- All scripts are executable (`chmod +x`)
- Scripts source `setup_env.sh` for environment variables
- Scripts use `set -e` for error handling
- Artifacts are named with commit hash and date for traceability
- Scripts support both local and CI/CD environments

## 🎉 Success!

Your Flutter automation toolkit is ready! Start with:

```bash
bash scripts/cli.sh setup
bash scripts/cli.sh diagnose
```

Then proceed with builds, releases, and deployments as needed.

