Here's the updated `README.md` with comprehensive ProGuard information:

# Flutter Groovy Template 🚀

A permanent, stable Gradle configuration for Flutter Android projects using Groovy.

## 📁 Template Structure

```
flutter_groovy_template/
├── README.md
├── android/
│   ├── settings.gradle          # ✅ REUSE AS-IS
│   ├── build.gradle            # ✅ REUSE AS-IS
│   ├── gradle.properties       # ✅ REUSE AS-IS
│   └── app/
│       ├── build.gradle        # 🎯 MODIFY 3 VALUES
│       └── proguard-rules.pro  # ✅ REUSE AS-IS (95% cases)
```

## 🚀 Quick Setup

### For New Flutter Projects:

1. **Copy** the entire `android/` folder from this template
2. **Paste** into your Flutter project root (replace existing)
3. **Modify** only 3 values in `android/app/build.gradle`
4. **Run**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

## 📋 File Modification Guide

### ✅ **DO NOT TOUCH - Reuse As-Is**

#### 1. `android/settings.gradle`

- **Purpose**: Flutter SDK detection and plugin management
- **Status**: ✅ REUSE AS-IS
- **Why**: Generic Flutter configuration, no app-specific changes needed

#### 2. `android/build.gradle`

- **Purpose**: Project-level dependencies and repositories
- **Status**: ✅ REUSE AS-IS
- **Why**: Standard Android/Flutter configuration

#### 3. `android/gradle.properties`

- **Purpose**: Gradle performance and AndroidX configuration
- **Status**: ✅ REUSE AS-IS
- **Why**: Optimized settings for all Flutter projects

#### 4. `android/app/proguard-rules.pro`

- **Purpose**: Code obfuscation and optimization rules
- **Status**: ✅ REUSE AS-IS (for 95% of projects)
- **Why**: Comprehensive Flutter ProGuard rules included

### 🎯 **MODIFY THESE - App-Specific Changes**

#### `android/app/build.gradle` - **ONLY MODIFY 3 VALUES**

```groovy
android {
    // 🎯 CHANGE #1: Package namespace (reverse DNS)
    namespace "com.yourcompany.yourapp"

    defaultConfig {
        // 🎯 CHANGE #2: Application ID (usually same as namespace)
        applicationId "com.yourcompany.yourapp"

        // 🎯 OPTIONAL: Change SDK versions if needed
        minSdk 21        // Minimum Android version
        targetSdk 36     // Target SDK (34+ required for Google Play)
        compileSdk 36    // Compilation SDK
    }
}
```

## 🛡️ ProGuard Configuration (For 5% Special Cases)

### When to Modify `proguard-rules.pro`:

#### 1. **Update Main Activity Class** (Most Common)

```proguard
# Replace with your actual main activity class
-keep class com.yourcompany.yourapp.MainActivity { *; }
```

#### 2. **Add Model Classes for JSON Serialization**

```proguard
# Add if you use json_serializable or similar
-keep class com.yourcompany.yourapp.models.** { *; }
```

#### 3. **Plugin-Specific Rules** (When Using These Plugins)

**Firebase:**

```proguard
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
```

**Camera/CameraX:**

```proguard
-keep class androidx.camera.** { *; }
```

**WebView/JavaScript Interface:**

```proguard
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
```

#### 4. **Native Code (JNI)**

```proguard
# Add if you have custom native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
```

#### 5. **Reflection-Heavy Libraries**

```proguard
# For libraries using reflection (Jackson, Gson, etc.)
-keepattributes Signature, RuntimeVisibleAnnotations
```

### ProGuard Troubleshooting:

**If build fails with "class not found" errors:**

1. Check plugin documentation for ProGuard rules
2. Add specific keep rules for missing classes
3. Test with `minifyEnabled false` first to isolate issues

**Common patterns to add:**

```proguard
# Keep specific plugin classes
-keep class com.some.plugin.** { *; }

# Keep methods with annotations
-keep @interface * { *; }
-keepclasseswithmembers class * {
    @com.some.Annotation <methods>;
}
```

## ⚙️ Optional Customizations

### Firebase Setup (If Needed):

1. **In `android/build.gradle`**:
   ```groovy
   dependencies {
       classpath "com.google.gms:google-services:4.4.2"  // Uncomment
   }
   ```

2. **In `android/app/build.gradle`**:
   ```groovy
   plugins {
       id "com.google.gms.google-services"  // Uncomment
   }
   ```

3. **Add** `google-services.json` to `android/app/`

### Release Signing (For Production):

```groovy
android {
    buildTypes {
        release {
            signingConfig signingConfigs.release  // Replace signingConfigs.debug
        }
    }
}
```

## 🛠️ Troubleshooting

### Common Issues:

1. **Build fails after copying**:
   ```bash
   flutter clean
   flutter pub get
   cd android && ./gradlew clean
   ```

2. **Version conflicts**: Ensure all SDK versions match in all files

3. **Plugin errors**: Verify `local.properties` exists with correct Flutter SDK path

4. **ProGuard issues**: Temporarily disable with `minifyEnabled false`

### Verification Commands:

```bash
# Test the configuration
flutter build apk

# Check for Gradle issues
cd android && ./gradlew clean

# Verify Flutter configuration
flutter doctor
```

## 📝 Version Compatibility

- **Flutter**: 3.0+
- **Gradle**: 8.7
- **Android Gradle Plugin**: 8.6.0
- **Kotlin**: 2.1.0
- **Minimum SDK**: 21
- **Target SDK**: 36 (Google Play compliant)

## 🔄 Updates

When Flutter updates Android requirements:

1. Update this template once
2. Copy to all projects
3. Run `flutter clean && flutter pub get`

## 📞 Support

This template solves:

- ✅ Gradle version conflicts
- ✅ Lint build failures
- ✅ Plugin application issues
- ✅ SDK version mismatches
- ✅ Build optimization
- ✅ ProGuard configuration (95% cases)

**For ProGuard issues**: 95% of Flutter projects work with the provided rules. Only modify if you
use specific plugins requiring custom rules.

**Happy Coding!** 🎉

---

*Template maintained for stable Flutter Android builds with Groovy configuration.*