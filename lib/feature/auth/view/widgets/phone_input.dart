import 'package:flutter/material.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const PhoneInput({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixText: '+91 ',
        border: OutlineInputBorder(),
      ),
    );
  }
}
