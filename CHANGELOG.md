# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial changelog

## [1.0.6] - 2025-11-26

### Added
- Automated release notes generation in CI/CD pipeline
- Performance optimizations for CI/CD builds (caching, parallelization)
- Deployment notifications via Discord webhooks
- Comprehensive CI/CD documentation and secret management scripts
- Firebase deployment with dedicated service account

### Changed
- Simplified production pipeline tag pattern from `v*.*.*` to `v*` for better reliability
- Enhanced workflow display names for better clarity in GitHub Actions

### Fixed
- Resolved YAML syntax error in production pipeline (line 1351) by replacing multi-line sed with awk
- Fixed leading blank line in production pipeline workflow causing improper display name
- Fixed Firebase deployment to wait for web build completion before deploying
- Improved secret verification to handle multiline JSON values properly

### Security
- Added dedicated Firebase Hosting deployment service account with minimal required permissions
- Enhanced secret verification with better error handling and debugging

[Unreleased]: https://github.com/bantirathodtech/atitia/compare/v1.0.6...HEAD
[1.0.6]: https://github.com/bantirathodtech/atitia/compare/v1.0.5...v1.0.6

