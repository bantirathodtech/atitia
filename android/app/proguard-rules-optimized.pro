# ============================================================================
# OPTIMIZED PROGUARD RULES - ENHANCED BUNDLE SIZE OPTIMIZATION
# ============================================================================
# Additional ProGuard rules for better code shrinking and obfuscation
# This file extends the base proguard-rules.pro for maximum optimization

# ============================================================================
# Aggressive Optimization Rules
# ============================================================================

# Remove unused code aggressively
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Remove debug-only code
-assumenosideeffects class * {
    @androidx.annotation.VisibleForTesting *;
}

# Optimize annotations (reduce annotation overhead)
-keepattributes *Annotation*,InnerClasses,Signature
-keepattributes EnclosingMethod
-keepattributes SourceFile,LineNumberTable

# ============================================================================
# Flutter-Specific Optimizations
# ============================================================================

# Keep only essential Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Optimize Flutter plugins (keep only what's needed)
-keep class io.flutter.plugins.firebase.** { *; }
-dontwarn io.flutter.plugins.firebase.**
-keep class io.flutter.plugins.connectivity.** { *; }
-dontwarn io.flutter.plugins.connectivity.**

# ============================================================================
# Code Shrinking Optimizations
# ============================================================================

# Remove unused string constants
-assumenosideeffects class java.lang.String {
    public java.lang.String intern();
}

# Optimize enum usage (replace with integers where possible)
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# ============================================================================
# Resource Shrinking
# ============================================================================

# Remove unused resources (handled by shrinkResources = true in build.gradle)
# Additional resource optimization rules can be added here

# ============================================================================
# Performance Optimizations
# ============================================================================

# Optimize method calls
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*

# Inline short methods
-optimizationpasses 5

# ============================================================================
# Security Enhancements
# ============================================================================

# Obfuscate class names for better security
-repackageclasses 'com.atitia.obfuscated'

