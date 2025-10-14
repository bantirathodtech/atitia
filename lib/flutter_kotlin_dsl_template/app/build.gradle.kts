// ==================================================
// Flutter Version Configuration (Kotlin DSL)
// ==================================================
// IMPORTANT: This block MUST read version before android block
// DO NOT PUT any code before plugins block

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // ==================================================
    // FIREBASE SETUP (Optional - Uncomment if using Firebase)
    // ==================================================
    // id("com.google.gms.google-services")
}

// ==================================================
// Version Properties (MUST be after plugins block)
// ==================================================
val localProperties = java.util.Properties()
val localPropertiesFile = file("local.properties")
if (localPropertiesFile.isFile) {
    localPropertiesFile.inputStream().use { inputStream ->
        localProperties.load(inputStream)
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

// ==================================================
// Android App Configuration (Kotlin DSL)
// ==================================================
android {
    // 🎯 CHANGE #1: Package namespace (reverse DNS)
    namespace = "com.yourcompany.yourapp"

    // ==================================================
    // SDK Configuration
    // ==================================================
    // Google Play requires targetSdkVersion 34+ from Aug 2024
    // You can use 36 (latest) but 34 is minimum requirement
    compileSdk = 36  // Can use 34, 35, or 36

    ndkVersion = "27.0.12077973"

    // ==================================================
    // Java/Kotlin Compilation Options
    // ==================================================
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // ==================================================
    // Default Configuration
    // ==================================================
    defaultConfig {
        // 🎯 CHANGE #2: Application ID (usually same as namespace)
        applicationId = "com.yourcompany.yourapp"

        minSdk = 21        // Minimum Android version supported
        targetSdk = 36     // Should match compileSdk (34, 35, or 36)
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    // ==================================================
    // Build Types
    // ==================================================
    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("release") {
            isMinifyEnabled = true    // Enable code shrinking for release
            isShrinkResources = true  // Enable resource shrinking for release
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // ==================================================
    // Lint Configuration
    // ==================================================
    // Disabled for release builds to prevent build failures
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

// ==================================================
// Dependencies
// ==================================================
dependencies {
    // Java 8+ desugaring for newer APIs on older devices
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // MultiDex for apps with many dependencies
    implementation("androidx.multidex:multidex:2.0.1")

    // Kotlin extensions for Android
    implementation("androidx.core:core-ktx:1.12.0")

    // ==================================================
    // FIREBASE DEPENDENCIES (Optional)
    // ==================================================
    // Uncomment if using Firebase:
    // implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    // implementation("com.google.firebase:firebase-analytics")
}

// ==================================================
// Flutter Configuration
// ==================================================
flutter {
    source = "../.."
}