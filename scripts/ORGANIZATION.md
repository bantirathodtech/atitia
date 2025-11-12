# 📁 Script Organization

All scripts have been organized into logical groups for better maintainability and discoverability.

## Directory Structure

```
scripts/
├── core/                    # Core build and environment scripts
│   ├── cli.sh              # ⭐ Main CLI wrapper (use this!)
│   ├── setup_env.sh         # Environment setup
│   ├── flutter_clean.sh     # Clean all platforms
│   ├── flutter_build.sh     # Build for platforms
│   └── diagnostics.sh       # Environment diagnostics
│
├── signing/                 # Signing and certificate management
│   ├── android_sign.sh      # Android signing setup
│   ├── ios_sign.sh          # iOS signing setup
│   ├── create-keystore.sh   # Generate keystore
│   ├── create-key-properties.sh
│   ├── generate-keystore-base64.sh
│   ├── setup-android-signing.sh
│   └── setup-ios-secrets.sh
│
├── release/                 # Release builds
│   ├── release_android.sh   # Android release build
│   ├── release_ios.sh       # iOS release build
│   ├── release_all.sh       # Full release workflow
│   └── build_web.sh         # Web build & deploy
│
├── deploy/                  # Deployment scripts
│   ├── deploy_playstore.sh  # Play Store upload
│   ├── deploy_appstore.sh   # App Store upload
│   └── deploy.sh            # Generic deploy script
│
├── dev/                     # Development utilities
│   ├── test_runner.sh       # Run tests
│   ├── version_bump.sh      # Version management
│   ├── generate_localization.sh
│   ├── generate_icons.sh
│   └── git_hooks.sh         # Git hooks setup
│
├── setup/                   # Setup and configuration
│   ├── firebase_setup.sh    # Firebase config
│   ├── setup_cicd.sh        # CI/CD setup
│   ├── setup-web-secrets.sh
│   └── secure-credentials-setup.sh
│
└── github/                  # GitHub-specific scripts
    ├── add-github-secrets.sh
    ├── add-secrets-github-api.sh
    ├── prepare-github-secrets.sh
    └── show-github-secrets.sh
```

## Migration Guide

### Old Paths → New Paths

| Old Path | New Path |
|----------|----------|
| `scripts/setup_env.sh` | `scripts/core/setup_env.sh` |
| `scripts/flutter_clean.sh` | `scripts/core/flutter_clean.sh` |
| `scripts/flutter_build.sh` | `scripts/core/flutter_build.sh` |
| `scripts/diagnostics.sh` | `scripts/core/diagnostics.sh` |
| `scripts/android_sign.sh` | `scripts/signing/android_sign.sh` |
| `scripts/ios_sign.sh` | `scripts/signing/ios_sign.sh` |
| `scripts/release_android.sh` | `scripts/release/release_android.sh` |
| `scripts/release_ios.sh` | `scripts/release/release_ios.sh` |
| `scripts/release_all.sh` | `scripts/release/release_all.sh` |
| `scripts/build_web.sh` | `scripts/release/build_web.sh` |
| `scripts/deploy_playstore.sh` | `scripts/deploy/deploy_playstore.sh` |
| `scripts/deploy_appstore.sh` | `scripts/deploy/deploy_appstore.sh` |
| `scripts/test_runner.sh` | `scripts/dev/test_runner.sh` |
| `scripts/version_bump.sh` | `scripts/dev/version_bump.sh` |
| `scripts/generate_localization.sh` | `scripts/dev/generate_localization.sh` |
| `scripts/generate_icons.sh` | `scripts/dev/generate_icons.sh` |
| `scripts/git_hooks.sh` | `scripts/dev/git_hooks.sh` |
| `scripts/firebase_setup.sh` | `scripts/setup/firebase_setup.sh` |
| `scripts/setup_cicd.sh` | `scripts/setup/setup_cicd.sh` |

### Recommended: Use CLI Wrapper

Instead of remembering paths, use the CLI wrapper:

```bash
# Old way (still works)
bash scripts/release/release_android.sh

# New way (recommended)
bash scripts/core/cli.sh release android
```

## Benefits of Organization

1. **Logical Grouping** - Scripts are grouped by purpose
2. **Easy Discovery** - Find scripts by category
3. **Better Maintainability** - Related scripts are together
4. **Scalable** - Easy to add new scripts to appropriate groups
5. **Clear Structure** - Intuitive directory layout

## Usage Examples

### Using CLI (Recommended)

```bash
# All commands work the same way
bash scripts/core/cli.sh [command] [args...]

# Examples
bash scripts/core/cli.sh setup
bash scripts/core/cli.sh build android
bash scripts/core/cli.sh release all
bash scripts/core/cli.sh deploy playstore
```

### Direct Script Calls

```bash
# Core scripts
bash scripts/core/flutter_clean.sh
bash scripts/core/flutter_build.sh android release

# Signing
bash scripts/signing/android_sign.sh configure
bash scripts/signing/ios_sign.sh setup

# Release
bash scripts/release/release_android.sh both
bash scripts/release/release_all.sh

# Deploy
bash scripts/deploy/deploy_playstore.sh internal
```

## Script Dependencies

All scripts:
- Source `core/setup_env.sh` for environment setup
- Use `$SCRIPTS_ROOT` to reference other scripts
- Calculate paths relative to their location

## Notes

- ✅ All scripts are executable
- ✅ All scripts updated to use new paths
- ✅ CLI wrapper handles path resolution automatically
- ✅ Direct script calls still work with full paths

