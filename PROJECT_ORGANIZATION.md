# 📁 Project Organization

This document describes the organization structure of the Atitia Flutter project.

## 🎯 Organization Principles

1. **Platform folders remain untouched** - android/, ios/, macos/, windows/, linux/, web/
2. **Code folder remains untouched** - lib/
3. **Developer-created files are organized** - Documentation, configs, scripts grouped logically
4. **CI/CD remains independent** - GitHub Actions workflows work independently

## 📂 Directory Structure

```
atitia/
├── 📱 Platform Folders (Untouched)
│   ├── android/          # Android platform code
│   ├── ios/              # iOS platform code
│   ├── macos/            # macOS platform code
│   ├── windows/          # Windows platform code
│   ├── linux/            # Linux platform code
│   └── web/              # Web platform code
│
├── 💻 Code (Untouched)
│   └── lib/              # Flutter application code
│
├── 📚 Documentation (Organized)
│   └── docs/
│       ├── guides/       # Setup guides and tutorials
│       ├── reports/      # Status reports and audits
│       └── deployment/    # Deployment and CI/CD docs
│
├── ⚙️ Configuration (Organized)
│   └── config/          # Configuration files (yaml, json)
│
├── 🛠️ Scripts (Organized)
│   └── scripts/         # Automation scripts (grouped by category)
│
├── 🗑️ Temporary Files (Organized)
│   └── temp/            # Temporary scripts and files
│
├── 📋 Logs (Organized)
│   └── logs/            # Log files
│
├── 🔐 Secrets (Secure)
│   └── .secrets/        # Secrets and credentials (gitignored)
│
└── 🔄 CI/CD (Independent)
    └── .github/workflows/  # GitHub Actions workflows
```

## 📁 Organized Directories

### `docs/` - Documentation

**Purpose**: All project documentation organized by category

- `guides/` - Setup guides, tutorials, step-by-step instructions
- `reports/` - Status reports, audits, project assessments
- `deployment/` - Deployment guides, CI/CD documentation

**Examples**:
- `docs/guides/CREATE_NEW_KEYSTORE_GUIDE.md`
- `docs/reports/PROJECT_STATUS_SUMMARY.md`
- `docs/deployment/DEPLOYMENT_GUIDE.md`

### `config/` - Configuration Files

**Purpose**: Configuration files for various tools and services

**Files**:
- `deployment_config.yaml` - Deployment configuration
- `codemagic.yaml` - Codemagic CI/CD config
- `firebase.json` - Firebase configuration
- `firestore.indexes.json` - Firestore indexes
- `firestore.rules` - Firestore security rules

### `scripts/` - Automation Scripts

**Purpose**: Automation scripts organized by category

**Structure**:
- `core/` - Core build and environment scripts
- `signing/` - Signing and certificate management
- `release/` - Release builds
- `deploy/` - Deployment scripts
- `dev/` - Development utilities
- `setup/` - Setup and configuration
- `github/` - GitHub-specific scripts

### `temp/` - Temporary Files

**Purpose**: Temporary scripts and files

**Files**:
- `fix_deprecated_apis.sh` - Temporary fix scripts
- `remove_debug_prints.sh` - Cleanup scripts
- `GITHUB_SECRETS_VALUES.txt` - Temporary text files
- `SECRETS_COPY_PASTE.txt` - Temporary text files

### `logs/` - Log Files

**Purpose**: Log files from builds and operations

**Files**:
- `flutter_*.log` - Flutter build logs

## 🚫 Untouched Directories

These directories remain in their original structure:

- ✅ `android/` - Android platform code
- ✅ `ios/` - iOS platform code
- ✅ `macos/` - macOS platform code
- ✅ `windows/` - Windows platform code
- ✅ `linux/` - Linux platform code
- ✅ `web/` - Web platform code
- ✅ `lib/` - Flutter application code
- ✅ `test/` - Test files
- ✅ `assets/` - Assets (images, fonts, etc.)

## 🔄 CI/CD Independence

GitHub Actions workflows (`.github/workflows/`) work independently:
- ✅ No dependencies on `scripts/` folder
- ✅ Direct Flutter commands used
- ✅ Self-contained workflow definitions
- ✅ No changes needed to workflows

## 📋 Root Directory Files

Essential files remain in root:
- `README.md` - Main project README
- `pubspec.yaml` - Flutter project configuration
- `pubspec.lock` - Dependency lock file
- `analysis_options.yaml` - Dart analysis options
- `l10n.yaml` - Localization configuration
- `.gitignore` - Git ignore rules

## 🎯 Benefits

1. **Clean root directory** - Easy to find important files
2. **Logical grouping** - Related files organized together
3. **Easy navigation** - Clear directory structure
4. **Maintainable** - Easy to add new files to appropriate locations
5. **Platform-safe** - Platform folders untouched
6. **CI/CD safe** - Workflows work independently

## 📝 Adding New Files

When adding new files:

1. **Documentation** → `docs/[category]/`
2. **Configuration** → `config/`
3. **Scripts** → `scripts/[category]/`
4. **Temporary files** → `temp/`
5. **Logs** → `logs/`
6. **Secrets** → `.secrets/[category]/`

## 🔍 Finding Files

- **Setup guides**: `docs/guides/`
- **Status reports**: `docs/reports/`
- **Deployment docs**: `docs/deployment/`
- **Config files**: `config/`
- **Scripts**: `scripts/[category]/`
- **Main README**: `README.md` (root)

---

**Last Updated**: $(date)  
**Status**: ✅ Organized - Platform folders and lib/ untouched

