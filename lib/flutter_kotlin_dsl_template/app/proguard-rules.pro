# ==================================================
# Flutter ProGuard Configuration
# ==================================================
# This file contains rules for code shrinking and obfuscation
# REUSE AS-IS for all Flutter projects

# ==================================================
# Flutter Engine Rules
# ==================================================
# Keep Flutter main classes and entry points
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ==================================================
# Platform Channel Communication
# ==================================================
# Keep method channel classes and methods
-keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel { *; }
-keep class * extends io.flutter.plugin.common.BasicMessageChannel { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry { *; }

# ==================================================
# Flutter Embedding
# ==================================================
# Keep Flutter embedding classes
-keep class io.flutter.embedding.** { *; }
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragment { *; }
-keep class * extends io.flutter.embedding.engine.FlutterEngine { *; }

# ==================================================
# JSON Serialization (if using json_serializable)
# ==================================================
# Keep model classes for JSON serialization
-keep class your.package.name.models.** { *; }

# ==================================================
# Reflection-based Libraries
# ==================================================
# Keep classes that use reflection (Jackson, Gson, etc.)
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# ==================================================
# Resource Classes (R8 automatic)
# ==================================================
# R8 automatically keeps these, but explicit rules for safety
-keepclassmembers class **.R$* {
    public static <fields>;
}

# ==================================================
# Native Methods (JNI)
# ==================================================
# Keep native method names for JNI
-keepclasseswithmembernames class * {
    native <methods>;
}

# ==================================================
# Parcelable Classes
# ==================================================
# Keep Parcelable classes and CREATOR fields
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# ==================================================
# View Binding and Data Binding
# ==================================================
# Keep view binding classes if used
-keep class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# ==================================================
# Third-Party Library Specific Rules
# ==================================================

# ==================================================
# Firebase (Uncomment if using Firebase)
# ==================================================
# -keep class com.google.firebase.** { *; }
# -keep class com.google.android.gms.** { *; }
# -keep class com.google.api.** { *; }
# -keepattributes *Annotation*

# ==================================================
# Google Play Services (Uncomment if using)
# ==================================================
# -keep class com.google.android.gms.** { *; }
# -keep class com.google.ar.** { *; }
# -keep class com.google.vr.** { *; }

# ==================================================
# AdMob (Uncomment if using ads)
# ==================================================
# -keep class com.google.ads.** { *; }
# -keep class com.google.android.gms.ads.** { *; }
# -keep public class com.google.android.gms.ads.R$* { public static final int *; }

# ==================================================
# Facebook (Uncomment if using Facebook SDK)
# ==================================================
# -keep class com.facebook.** { *; }
# -keepattributes Signature

# ==================================================
# CameraX (Uncomment if using camera)
# ==================================================
# -keep class androidx.camera.** { *; }

# ==================================================
# SQLite (Uncomment if using local database)
# ==================================================
# -keep class android.database.sqlite.** { *; }

# ==================================================
# WebView (Uncomment if using webview)
# ==================================================
# -keep class android.webkit.** { *; }

# ==================================================
# Common Issues Prevention
# ==================================================
# Prevent common issues with method parameters
-dontwarn android.support.**
-dontwarn androidx.**

# Remove logging in release builds (optional)
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# ==================================================
# Performance Optimizations
# ==================================================
# Optimize the code
-optimizations !code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# ==================================================
# Generic Keep Rules
# ==================================================
# Keep generic application classes
-keep public class * extends android.app.Application
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Fragment
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgent
-keep public class * extends android.preference.Preference

# ==================================================
# ENTRY POINT - Main Activity
# ==================================================
# Keep your main activity (replace with your actual activity name)
-keep class your.package.name.MainActivity { *; }

# ==================================================
# END OF PROGUARD RULES
# ==================================================