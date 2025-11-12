# 🛠️ Flutter Automation Scripts

Universal automation toolkit for Flutter app development, builds, signing, testing, releases, and CI/CD.

## 📁 Directory Structure

Scripts are organized into logical groups:

```
scripts/
├── core/              # Core build and environment scripts
│   ├── cli.sh         # CLI wrapper (main entry point)
│   ├── setup_env.sh   # Environment setup
│   ├── flutter_clean.sh
│   ├── flutter_build.sh
│   └── diagnostics.sh
│
├── signing/           # Signing and certificate management
│   ├── android_sign.sh
│   ├── ios_sign.sh
│   ├── create-keystore.sh
│   └── ...
│
├── release/           # Release builds
│   ├── release_android.sh
│   ├── release_ios.sh
│   ├── release_all.sh
│   └── build_web.sh
│
├── deploy/            # Deployment scripts
│   ├── deploy_playstore.sh
│   ├── deploy_appstore.sh
│   └── deploy.sh
│
├── dev/               # Development utilities
│   ├── test_runner.sh
│   ├── version_bump.sh
│   ├── generate_localization.sh
│   ├── generate_icons.sh
│   └── git_hooks.sh
│
├── setup/             # Setup and configuration
│   ├── firebase_setup.sh
│   ├── setup_cicd.sh
│   └── ...
│
└── github/            # GitHub-specific scripts
    ├── add-github-secrets.sh
    └── ...
```

## 🚀 Quick Start

### Using the CLI (Recommended)

```bash
# Show help
bash scripts/core/cli.sh help

# Setup and verify
bash scripts/core/cli.sh setup
bash scripts/core/cli.sh diagnose

# Build
bash scripts/core/cli.sh build android
bash scripts/core/cli.sh build all

# Release
bash scripts/core/cli.sh release android
bash scripts/core/cli.sh release all

# Deploy
bash scripts/core/cli.sh deploy playstore
bash scripts/core/cli.sh deploy all
```

### Direct Script Usage

```bash
# Core scripts
bash scripts/core/setup_env.sh
bash scripts/core/flutter_clean.sh
bash scripts/core/flutter_build.sh android release
bash scripts/core/diagnostics.sh

# Signing
bash scripts/signing/android_sign.sh configure
bash scripts/signing/ios_sign.sh setup

# Release
bash scripts/release/release_android.sh both
bash scripts/release/release_ios.sh
bash scripts/release/release_all.sh

# Deploy
bash scripts/deploy/deploy_playstore.sh internal
bash scripts/deploy/deploy_appstore.sh

# Development
bash scripts/dev/test_runner.sh all yes
bash scripts/dev/version_bump.sh patch
bash scripts/dev/generate_localization.sh
```

## 📋 Script Categories

### Core Scripts (`core/`)

Essential scripts for environment setup and builds:

| Script | Purpose | Usage |
|--------|---------|-------|
| `cli.sh` | CLI wrapper (main entry point) | `bash scripts/core/cli.sh [command]` |
| `setup_env.sh` | Environment setup | `source scripts/core/setup_env.sh` |
| `flutter_clean.sh` | Clean all build artifacts | `bash scripts/core/flutter_clean.sh` |
| `flutter_build.sh` | Build for platforms | `bash scripts/core/flutter_build.sh [platform]` |
| `diagnostics.sh` | Verify environment | `bash scripts/core/diagnostics.sh` |

### Signing Scripts (`signing/`)

Manage certificates and signing configuration:

| Script | Purpose | Usage |
|--------|---------|-------|
| `android_sign.sh` | Android signing setup | `bash scripts/signing/android_sign.sh [generate\|configure\|verify]` |
| `ios_sign.sh` | iOS signing setup | `bash scripts/signing/ios_sign.sh [setup\|verify]` |
| `create-keystore.sh` | Generate Android keystore | `bash scripts/signing/create-keystore.sh` |

### Release Scripts (`release/`)

Build release artifacts:

| Script | Purpose | Usage |
|--------|---------|-------|
| `release_android.sh` | Android release build | `bash scripts/release/release_android.sh [aab\|apk\|both]` |
| `release_ios.sh` | iOS release build | `bash scripts/release/release_ios.sh` |
| `build_web.sh` | Web build & deploy | `bash scripts/release/build_web.sh [deploy]` |
| `release_all.sh` | Full release workflow | `bash scripts/release/release_all.sh [deploy]` |

### Deployment Scripts (`deploy/`)

Deploy to app stores:

| Script | Purpose | Usage |
|--------|---------|-------|
| `deploy_playstore.sh` | Play Store upload | `bash scripts/deploy/deploy_playstore.sh [track]` |
| `deploy_appstore.sh` | App Store upload | `bash scripts/deploy/deploy_appstore.sh` |

### Development Scripts (`dev/`)

Development utilities:

| Script | Purpose | Usage |
|--------|---------|-------|
| `test_runner.sh` | Run tests | `bash scripts/dev/test_runner.sh [type] [coverage]` |
| `version_bump.sh` | Bump version | `bash scripts/dev/version_bump.sh [type]` |
| `generate_localization.sh` | Generate l10n | `bash scripts/dev/generate_localization.sh` |
| `generate_icons.sh` | Generate icons | `bash scripts/dev/generate_icons.sh` |
| `git_hooks.sh` | Git hooks | `bash scripts/dev/git_hooks.sh [install\|uninstall]` |

### Setup Scripts (`setup/`)

Configuration and setup:

| Script | Purpose | Usage |
|--------|---------|-------|
| `firebase_setup.sh` | Firebase config | `bash scripts/setup/firebase_setup.sh [platform]` |
| `setup_cicd.sh` | CI/CD setup | `bash scripts/setup/setup_cicd.sh [platform]` |

### GitHub Scripts (`github/`)

GitHub-specific automation:

| Script | Purpose | Usage |
|--------|---------|-------|
| `add-github-secrets.sh` | Add GitHub secrets | `bash scripts/github/add-github-secrets.sh` |
| `show-github-secrets.sh` | List GitHub secrets | `bash scripts/github/show-github-secrets.sh` |

## 🎯 Common Workflows

### Full Release Workflow

```bash
# 1. Setup and verify
bash scripts/core/cli.sh setup

# 2. Bump version
bash scripts/core/cli.sh version patch

# 3. Run tests
bash scripts/core/cli.sh test all

# 4. Build releases
bash scripts/core/cli.sh release all

# 5. Deploy
bash scripts/core/cli.sh deploy all
```

### Android-Only Release

```bash
bash scripts/release/release_android.sh both
bash scripts/deploy/deploy_playstore.sh internal
```

### iOS-Only Release

```bash
bash scripts/release/release_ios.sh
bash scripts/deploy/deploy_appstore.sh
```

## 📚 Documentation

- **Complete Guide**: See `AUTOMATION_TOOLKIT.md` in project root
- **Quick Reference**: See `QUICK_REFERENCE.md`
- **Secrets Guide**: See `.secrets/README.md`

## 🔧 Script Organization Benefits

- ✅ **Logical grouping** - Easy to find scripts by purpose
- ✅ **Clear structure** - Intuitive directory layout
- ✅ **Maintainable** - Related scripts grouped together
- ✅ **Scalable** - Easy to add new scripts to appropriate groups

## 💡 Tips

1. **Use the CLI wrapper** (`cli.sh`) for most tasks - it handles paths automatically
2. **Direct script calls** work too - just use the full path: `scripts/[category]/[script].sh`
3. **All scripts** source `core/setup_env.sh` for consistent environment
4. **Scripts reference each other** using `$SCRIPTS_ROOT` for path resolution

## 🔒 Security

- All secrets are in `.secrets/` (gitignored)
- Scripts use environment variables from `.secrets/common/.env`
- Never commit `.secrets/` directory
