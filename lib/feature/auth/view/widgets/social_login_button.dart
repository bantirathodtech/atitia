import 'package:flutter/material.dart';

enum SocialLoginType { google, facebook }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    IconData icon;

    switch (type) {
      case SocialLoginType.google:
        label = 'Continue with Google';
        color = Colors.redAccent;
        icon = Icons.g_mobiledata;
        break;
      case SocialLoginType.facebook:
        label = 'Continue with Facebook';
        color = Colors.blue;
        icon = Icons.facebook;
        break;
      // default:
      //   label = 'Continue';
      //   color = Theme.of(context).primaryColor;
      //   icon = Icons.login;
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 48),
      ),
    );
  }
}
