import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties file
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.avishio.atitia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Application ID - Must match EnvironmentConfig.packageName
        // This ID uniquely identifies your app on the Google Play Store
        // Reference: lib/common/constants/environment_config.dart
        applicationId = "com.avishio.atitia"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
        minSdk = flutter.minSdkVersion  // Changed from flutter.minSdkVersion to 21 for Play Integrity
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { rootProject.file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Use release signing config if available, otherwise fallback to debug
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            
            // ✅ PRODUCTION: Enable code shrinking and obfuscation for release builds
            // This reduces APK size and makes reverse engineering more difficult
            // ProGuard rules are configured in proguard-rules.pro
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
dependencies {
    // ✅ CORRECT: Kotlin DSL syntax for Play Integrity dependency
    implementation("com.google.firebase:firebase-appcheck-playintegrity")
    
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

// ============================================================================
// FIX: Remove integration_test plugin from release builds
// ============================================================================
// GeneratedPluginRegistrant.java includes integration_test (dev_dependency)
// which causes release builds to fail because the plugin class doesn't exist.
// Solution: Remove integration_test registration lines before compilation.
// ============================================================================

tasks.register("removeIntegrationTestFromRelease") {
    description = "Removes integration_test plugin from GeneratedPluginRegistrant.java for release builds"
    group = "flutter"
    
    doLast {
        val generatedFile = file("src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java")
        if (generatedFile.exists()) {
            var content = generatedFile.readText()
            val originalContent = content
            
            // Remove the integration_test try-catch block
            // Pattern: try { ... IntegrationTestPlugin() ... } catch ...
            val lines = content.lines().toMutableList()
            val filteredLines = mutableListOf<String>()
            
            var i = 0
            while (i < lines.size) {
                val line = lines[i]
                val trimmed = line.trim()
                
                // Check if this line starts the integration_test try block
                if (trimmed == "try {" && i + 1 < lines.size && 
                    lines[i + 1].contains("integration_test")) {
                    // Skip this try block - find and skip until end of catch block
                    var j = i
                    var braceCount = 0
                    while (j < lines.size) {
                        val currentLine = lines[j]
                        braceCount += currentLine.count { it == '{' } - currentLine.count { it == '}' }
                        if (currentLine.trim().startsWith("}") && braceCount == 0 && j > i) {
                            // End of catch block
                            i = j + 1
                            break
                        }
                        j++
                    }
                    if (j >= lines.size) break
                    continue
                }
                
                // Keep all other lines
                filteredLines.add(line)
                i++
            }
            
            content = filteredLines.joinToString("\n")
            
            if (content != originalContent) {
                generatedFile.writeText(content)
                println("✅ Removed integration_test plugin registration from GeneratedPluginRegistrant.java")
            }
        }
    }
}

// Execute removal task before compiling release Java code
afterEvaluate {
    tasks.findByName("compileReleaseJavaWithJavac")?.dependsOn("removeIntegrationTestFromRelease")
}
