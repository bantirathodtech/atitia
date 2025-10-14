import 'package:flutter/material.dart';

class OtpForm extends StatelessWidget {
  final TextEditingController controller;

  const OtpForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      decoration: InputDecoration(
        labelText: 'Enter OTP',
        border: OutlineInputBorder(),
      ),
    );
  }
}
