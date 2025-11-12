# Icon Style Guidelines
**Last Updated:** January 2025  
**App:** Atitia PG Management Platform

---

## Overview

This document establishes consistent icon usage patterns across the Atitia app to ensure visual consistency and better user experience.

---

## Icon Style Rules

### 1. Filled vs Outlined Icons

**General Rule:** Use **outlined icons** for most UI elements, **filled icons** for selected/active states.

#### Outlined Icons (Default)
- Use for unselected states
- Use for navigation items (when not selected)
- Use for action buttons
- Use for informational displays

**Examples:**
- `Icons.home_outlined` - Unselected home tab
- `Icons.person_outline` - Unselected profile tab
- `Icons.settings_outline` - Settings button
- `Icons.info_outline` - Information icon

#### Filled Icons (Selected/Active)
- Use for selected navigation items
- Use for active states
- Use for primary actions (when appropriate)

**Examples:**
- `Icons.home` - Selected home tab
- `Icons.person` - Selected profile tab
- `Icons.favorite` - Favorite item (filled heart)
- `Icons.star` - Rated/featured item

### 2. Icon Sizes

Use consistent icon sizes based on context:

| Context | Size | Usage |
|---------|------|-------|
| **App Bar Icons** | 24px | Action buttons, menu icons |
| **Bottom Navigation** | 24px | Tab icons |
| **List Items** | 20-24px | Secondary actions, indicators |
| **Cards** | 24-32px | Feature icons, status indicators |
| **Empty States** | 48-64px | Large display icons |
| **Error States** | 64px | Error icons |
| **Splash Screen** | 80-200px | Responsive based on screen size |

### 3. Icon Colors

#### Theme-Aware Colors
- Use `Theme.of(context).iconTheme.color` for default icons
- Use `Theme.of(context).primaryColor` for primary actions
- Use `Theme.of(context).colorScheme.error` for error states
- Use `Theme.of(context).colorScheme.secondary` for secondary actions

#### Semantic Colors
- **Error/Alert:** `Colors.red` or `AppColors.error`
- **Success:** `Colors.green` or `AppColors.success`
- **Info:** `Colors.blue` or `AppColors.info`
- **Warning:** `Colors.orange` or `AppColors.warning`

### 4. Bottom Navigation Icons

**Pattern:** Use outlined icons for unselected, filled icons for selected.

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined), // Unselected
  activeIcon: Icon(Icons.home),     // Selected
  label: 'Home',
)
```

### 5. Action Button Icons

**Pattern:** Use outlined icons for most actions, filled for primary actions.

- **Primary Actions:** Can use filled icons (`Icons.add`, `Icons.save`)
- **Secondary Actions:** Use outlined icons (`Icons.edit_outlined`, `Icons.delete_outline`)
- **Tertiary Actions:** Use outlined icons (`Icons.more_vert`, `Icons.info_outline`)

### 6. Status Indicators

**Pattern:** Use filled icons for active states, outlined for inactive.

- **Favorite:** `Icons.favorite` (filled) vs `Icons.favorite_border` (outlined)
- **Bookmark:** `Icons.bookmark` (filled) vs `Icons.bookmark_border` (outlined)
- **Star:** `Icons.star` (filled) vs `Icons.star_border` (outlined)

---

## Implementation Examples

### Bottom Navigation
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.dashboard_outlined),
  activeIcon: Icon(Icons.dashboard),
  label: 'Dashboard',
)
```

### Action Button
```dart
IconButton(
  icon: Icon(Icons.edit_outlined),
  onPressed: () => _editItem(),
)
```

### Status Indicator
```dart
Icon(
  _isFavorite ? Icons.favorite : Icons.favorite_border,
  color: _isFavorite ? Colors.red : Colors.grey,
)
```

---

## Migration Checklist

- [ ] Review all bottom navigation icons
- [ ] Update unselected icons to outlined versions
- [ ] Ensure selected icons use filled versions
- [ ] Standardize icon sizes across the app
- [ ] Use theme-aware colors consistently
- [ ] Document any exceptions

---

## Exceptions

Some icons don't have outlined/filled variants. In these cases:
- Use the available variant consistently
- Document the exception
- Consider using `IconTheme` to style consistently

---

## Best Practices

1. **Consistency First:** Use the same icon style for similar actions
2. **Accessibility:** Ensure icons have proper semantic labels
3. **Size Matters:** Use appropriate sizes for context
4. **Color Coding:** Use semantic colors for status indicators
5. **Theme Support:** Always use theme-aware colors

---

## Resources

- [Material Icons](https://fonts.google.com/icons)
- [Flutter Icon Widget](https://api.flutter.dev/flutter/widgets/Icon-class.html)
- [Material Design Icons](https://material.io/design/iconography/system-icons.html)

