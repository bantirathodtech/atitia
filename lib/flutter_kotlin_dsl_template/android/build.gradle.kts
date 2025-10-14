// ==================================================
// Project-level Build Configuration (Kotlin DSL)
// ==================================================
// This file defines dependencies for ALL modules in the project

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ==================================================
        // VERSION CONSISTENCY - Must match settings.gradle.kts
        // ==================================================
        classpath("com.android.tools.build:gradle:8.6.0") // Must match settings.gradle.kts
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Must match settings.gradle.kts

        // ==================================================
        // FIREBASE SETUP (Optional - Uncomment if using Firebase)
        // ==================================================
        // classpath("com.google.gms:google-services:4.4.2")
    }
}

// ==================================================
// Repository Configuration for ALL modules
// ==================================================
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ==================================================
// Build Directory Configuration
// ==================================================
rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

subprojects {
    project.evaluationDependsOn(":app")
}

// ==================================================
// Clean Task
// ==================================================
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}