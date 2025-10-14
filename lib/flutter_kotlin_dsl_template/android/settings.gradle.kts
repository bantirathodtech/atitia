// ==================================================
// Flutter Android Settings Configuration (Kotlin DSL)
// ==================================================
// DO NOT ADD: Regular code before pluginManagement block
// ONLY ALLOWED: pluginManagement, plugins blocks at top level

pluginManagement {
    val localPropertiesFile = file("local.properties")
    val properties = java.util.Properties()

    if (localPropertiesFile.isFile) {
        localPropertiesFile.inputStream().use { inputStream ->
            properties.load(inputStream)
        }
    }

    val flutterSdkPath = properties.getProperty("flutter.sdk")
        ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

    includeBuild(File(flutterSdkPath, "packages/flutter_tools/gradle"))

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// ==================================================
// Plugin Declarations (Kotlin DSL)
// ==================================================
// DO NOT ADD: Any other code before this plugins block

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.6.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")