// Basic usage (works on all platforms with native styling)
PrimaryButton(
onPressed: () => print('Button pressed'),
label: 'Save Changes',
)

// With icon and loading state (platform-optimized)
PrimaryButton(
onPressed: _saveData,
label: 'Save Data',
icon: Icons.save,
isLoading: _isLoading,
)

// Custom styling with new parameters
PrimaryButton(
onPressed: () {},
label: 'Custom Button',
backgroundColor: Colors.blue,
height: 60,
semanticLabel: 'Save user profile data',
)