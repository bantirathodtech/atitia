# Theme Toggle Positioning Guidelines
**Last Updated:** January 2025  
**App:** Atitia PG Management Platform

---

## Overview

This document establishes consistent theme toggle positioning across the Atitia app to ensure visual consistency and better user experience.

---

## Standard Position

**Primary Position:** Top-right corner of the screen/app bar

### Implementation Patterns

#### 1. App Bar Actions (Standard)
**Location:** Right side of app bar, as the last action item

**Implementation:**
```dart
AdaptiveAppBar(
  showThemeToggle: true, // Automatically positions in top-right
  actions: [
    // Other actions come first
    IconButton(...),
    // Theme toggle is automatically added at the end
  ],
)
```

**Used in:**
- Most dashboard screens
- Profile screens
- Settings screens
- All screens using `AdaptiveAppBar`

#### 2. Floating Button (Special Cases)
**Location:** Top-right corner, floating over content

**Implementation:**
```dart
Stack(
  children: [
    // Main content
    SingleChildScrollView(...),
    
    // Floating theme toggle
    Positioned(
      top: AppSpacing.paddingM,
      right: AppSpacing.paddingM,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(...),
          child: const ThemeToggleButton(),
        ),
      ),
    ),
  ],
)
```

**Used in:**
- Role selection screen (before login)
- Splash screen (if needed)
- Any screen without app bar

#### 3. Drawer/Settings (Alternative)
**Location:** Inside drawer or settings panel

**Implementation:**
```dart
Drawer(
  child: ListView(
    children: [
      // Theme toggle section
      ThemeModeSelector(), // Shows all options
      // OR
      ThemeToggleButton(showLabel: true), // Compact toggle
    ],
  ),
)
```

**Used in:**
- Settings screens
- Drawer menus
- Preference panels

---

## Positioning Rules

### 1. Standard Screens (with App Bar)
- **Position:** App bar actions (right side)
- **Order:** Last item in actions list
- **Spacing:** Standard app bar spacing
- **Implementation:** Use `AdaptiveAppBar` with `showThemeToggle: true`

### 2. Auth Screens (no App Bar)
- **Position:** Floating button, top-right corner
- **Spacing:** `AppSpacing.paddingM` from edges
- **Safe Area:** Always wrap in `SafeArea`
- **Elevation:** Use container with shadow for visibility

### 3. Settings/Drawer
- **Position:** Inside drawer/settings panel
- **Style:** Can use `ThemeModeSelector` for full options
- **Location:** Near top of drawer, after profile section

---

## Visual Consistency

### Spacing
- **App Bar:** Standard app bar icon spacing
- **Floating:** `AppSpacing.paddingM` (16px) from edges
- **Drawer:** `AppSpacing.paddingM` padding

### Styling
- **App Bar:** Standard `IconButton` size (24px)
- **Floating:** Container with shadow, rounded corners
- **Drawer:** Full-width option or compact button

### Colors
- **App Bar:** Theme-aware icon color
- **Floating:** Surface color with shadow
- **Drawer:** Theme-aware background

---

## Current Implementation Status

### ✅ Consistent Positioning
- **AdaptiveAppBar:** All screens using `AdaptiveAppBar` have consistent top-right positioning
- **Role Selection Screen:** Floating button in top-right (consistent with auth screens)
- **Drawer:** Theme toggle available in drawer menus

### 📋 Checklist
- [x] App bar theme toggle positioned consistently
- [x] Floating theme toggle for auth screens
- [x] Drawer theme toggle available
- [x] Safe area handling for floating buttons
- [x] Consistent spacing and styling

---

## Best Practices

1. **Always Use AdaptiveAppBar:** For screens with app bars, use `AdaptiveAppBar` with `showThemeToggle: true`
2. **Floating for Auth:** Use floating button pattern for screens without app bars
3. **Safe Area:** Always wrap floating buttons in `SafeArea`
4. **Consistent Spacing:** Use `AppSpacing.paddingM` for floating buttons
5. **Visual Hierarchy:** Theme toggle should be visible but not dominant

---

## Migration Notes

All screens should use one of these patterns:
- **Dashboard screens:** `AdaptiveAppBar(showThemeToggle: true)`
- **Auth screens:** Floating button in top-right
- **Settings:** `ThemeModeSelector` in settings panel

---

## Resources

- `lib/common/widgets/app_bars/adaptive_app_bar.dart` - Standard app bar implementation
- `lib/common/widgets/buttons/theme_toggle_button.dart` - Theme toggle button widget
- `lib/feature/auth/view/screen/role_selection/role_selection_screen.dart` - Floating button example










