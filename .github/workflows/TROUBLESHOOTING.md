# 🔧 CI/CD Pipeline Troubleshooting Guide

Common issues and solutions for the CI/CD pipeline.

## Build Failures

### iOS Build Timeout
**Symptoms**: iOS build takes >45 minutes or times out

**Solutions**:
1. Check cache hit rate - should be >80% after first build
2. Verify CocoaPods cache is working
3. Check if `Podfile.lock` exists and is committed
4. Review build logs for specific slow steps

**Debug Steps**:
```bash
# Check cache status in workflow logs
# Look for "Cache CocoaPods" step output
# Verify Podfile.lock is in repository
```

### Android Build Fails
**Symptoms**: Android build fails with signing or Gradle errors

**Solutions**:
1. Verify `ANDROID_KEYSTORE_BASE64` secret is set
2. Check `android/key.properties` is not committed (should use secrets)
3. Verify Java version matches (should be 17)
4. Clear Gradle cache if needed

**Debug Steps**:
```bash
# Check if keystore secret is configured
# Verify key.properties format
# Check Gradle version compatibility
```

### Web Build Fails
**Symptoms**: Web build fails or produces errors

**Solutions**:
1. Check Flutter web support is enabled
2. Verify all web dependencies are compatible
3. Check browser compatibility issues
4. Review web-specific build logs

## Test Failures

### Tests Fail Unexpectedly
**Symptoms**: Tests pass locally but fail in CI

**Solutions**:
1. Check if Firebase/network dependencies are mocked
2. Verify test environment matches CI
3. Check for platform-specific issues
4. Review test logs for specific failures

**Debug Steps**:
```bash
# Run tests locally with CI flags
flutter test --no-pub --coverage

# Check for Firebase dependencies
grep -r "firebase" test/
```

### Coverage Not Generated
**Symptoms**: Coverage reports missing or empty

**Solutions**:
1. Verify `--coverage` flag is used
2. Check if `coverage/` directory exists
3. Download coverage artifacts from GitHub Actions
4. Check test execution completed successfully

## Security Audit Failures

### Critical Vulnerabilities Found
**Symptoms**: Security audit fails with critical/high severity issues

**Solutions**:
1. Review vulnerability details in audit output
2. Update vulnerable dependencies
3. Check if vulnerabilities are false positives
4. Consider using dependency overrides if needed

**Debug Steps**:
```bash
# Run audit locally
flutter pub audit

# Check specific package
flutter pub audit --help
```

## Dependency Issues

### Pub Get Fails
**Symptoms**: `flutter pub get` fails in CI

**Solutions**:
1. Check `pubspec.lock` is committed
2. Verify all dependencies are available
3. Check for version conflicts
4. Review network connectivity issues

**Debug Steps**:
```bash
# Clear pub cache
flutter pub cache repair

# Check dependency tree
flutter pub deps
```

### CocoaPods Install Fails
**Symptoms**: `pod install` fails or times out

**Solutions**:
1. Verify `Podfile.lock` exists
2. Check CocoaPods cache is working
3. Try clearing CocoaPods cache
4. Verify iOS deployment target compatibility

**Debug Steps**:
```bash
# Clear CocoaPods cache
cd ios
pod cache clean --all
pod install --repo-update
```

## Cache Issues

### Cache Not Working
**Symptoms**: Builds don't benefit from caching

**Solutions**:
1. Verify cache keys are correct
2. Check cache size limits (10GB per repo)
3. Verify cache restore keys match
4. Check if cache was invalidated

**Debug Steps**:
- Review cache step logs
- Check cache hit/miss status
- Verify cache key generation

## Performance Issues

### Slow Build Times
**Symptoms**: Builds take longer than expected

**Solutions**:
1. Check cache hit rates
2. Verify parallel execution is working
3. Review timeout settings
4. Check runner resource availability

**Performance Targets**:
- First build: ~25-30 min (iOS), ~5-8 min (Android/Web)
- Subsequent builds: ~5-10 min (iOS), ~3-5 min (Android/Web)

## Common Error Messages

### "The operation was canceled"
**Cause**: Job timeout exceeded

**Solution**: Check timeout settings, optimize build steps, verify caching

### "No such file or directory"
**Cause**: Missing files or incorrect paths

**Solution**: Verify file paths, check checkout step, verify file existence

### "Permission denied"
**Cause**: File permissions or keychain access issues

**Solution**: Check file permissions, verify keychain setup (iOS), check secret configuration

## Getting Help

1. **Check Workflow Logs**: Review detailed logs in GitHub Actions
2. **Review Documentation**: Check `.github/workflows/` documentation files
3. **Test Locally**: Reproduce issues locally with same commands
4. **Check Dependencies**: Verify all dependencies are up to date

## Useful Commands

```bash
# Test CI commands locally
flutter analyze --no-fatal-infos --no-fatal-warnings
dart format --set-exit-if-changed .
flutter test --no-pub --coverage

# Check Flutter version
flutter --version

# Verify dependencies
flutter pub deps
flutter pub audit

# Build locally
flutter build apk --debug
flutter build ios --no-codesign --release
flutter build web --release
```

---

**Last Updated**: $(date)  
**Pipeline Version**: 2.0

