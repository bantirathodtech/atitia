// Basic usage (works on all platforms with native styling)
AdaptiveAppBar(title: 'My Screen')

// With custom actions (platform-optimized)
AdaptiveAppBar(
title: 'Dashboard',
actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
)

// With gradient background (works across all platforms)
AdaptiveAppBar(
title: 'Premium Screen',
backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
)