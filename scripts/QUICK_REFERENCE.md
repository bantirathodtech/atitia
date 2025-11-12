# 🚀 Quick Reference Guide

## Most Common Commands

### Using CLI (Recommended)

```bash
# Setup (first time)
bash scripts/core/cli.sh setup

# Check everything is OK
bash scripts/core/cli.sh diagnose

# Build Android release
bash scripts/core/cli.sh release android

# Build iOS release
bash scripts/core/cli.sh release ios

# Deploy Android to Play Store
bash scripts/core/cli.sh deploy playstore

# Deploy iOS to App Store
bash scripts/core/cli.sh deploy appstore

# Full release workflow
bash scripts/core/cli.sh release all
bash scripts/core/cli.sh deploy all
```

### Direct Script Calls

```bash
# Build Android release
bash scripts/release/release_android.sh both

# Build iOS release
bash scripts/release/release_ios.sh

# Deploy Android to Play Store
bash scripts/deploy/deploy_playstore.sh internal

# Deploy iOS to App Store
bash scripts/deploy/deploy_appstore.sh

# Full release workflow
bash scripts/release/release_all.sh yes
```

## Environment Setup

```bash
# Load environment (use in other scripts)
source scripts/core/setup_env.sh

# Or use CLI
bash scripts/core/cli.sh setup
```

## Signing Setup

```bash
# Android
bash scripts/signing/android_sign.sh generate   # First time
bash scripts/signing/android_sign.sh configure # Configure
bash scripts/signing/android_sign.sh verify    # Verify

# iOS
bash scripts/signing/ios_sign.sh setup   # Setup
bash scripts/signing/ios_sign.sh verify   # Verify
```

## Build Commands

```bash
# Clean everything
bash scripts/core/flutter_clean.sh

# Build specific platform
bash scripts/core/flutter_build.sh android release
bash scripts/core/flutter_build.sh ios release
bash scripts/core/flutter_build.sh web release

# Build all platforms
bash scripts/core/flutter_build.sh all release
```

## Testing

```bash
# Run all tests with coverage
bash scripts/dev/test_runner.sh all yes

# Run specific tests
bash scripts/dev/test_runner.sh unit yes
bash scripts/dev/test_runner.sh widget yes
bash scripts/dev/test_runner.sh integration yes
```

## Version Management

```bash
# Bump build number (1.0.0+1 -> 1.0.0+2)
bash scripts/dev/version_bump.sh build

# Bump patch (1.0.0 -> 1.0.1)
bash scripts/dev/version_bump.sh patch

# Bump minor (1.0.0 -> 1.1.0)
bash scripts/dev/version_bump.sh minor

# Bump major (1.0.0 -> 2.0.0)
bash scripts/dev/version_bump.sh major
```

## Deployment

```bash
# Play Store (tracks: internal, alpha, beta, production)
bash scripts/deploy/deploy_playstore.sh internal

# App Store
bash scripts/deploy/deploy_appstore.sh

# Web (Firebase Hosting)
bash scripts/release/build_web.sh yes
```

## Utilities

```bash
# Generate icons
bash scripts/dev/generate_icons.sh

# Generate localization
bash scripts/dev/generate_localization.sh

# Setup Firebase
bash scripts/setup/firebase_setup.sh all

# Install git hooks
bash scripts/dev/git_hooks.sh install
```

## Troubleshooting

```bash
# Run diagnostics
bash scripts/core/diagnostics.sh

# Clean and rebuild
bash scripts/core/flutter_clean.sh
bash scripts/core/flutter_build.sh all
```

## CLI Wrapper (All-in-One)

```bash
# Show help
bash scripts/core/cli.sh help

# All commands via CLI
bash scripts/core/cli.sh [command] [args...]
```

