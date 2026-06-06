import 'package:flutter/material.dart';

class ValidatedTextField extends StatelessWidget {
  const ValidatedTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.isRequired = false,
    this.initialValue,
    this.maxLines = 1,
    this.enabled = true,
  }) : assert(
          controller == null || initialValue == null,
          'Cannot supply both controller and initialValue',
        );

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool isRequired;
  final String? initialValue;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final displayLabel = isRequired ? '$label *' : label;
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: displayLabel,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
