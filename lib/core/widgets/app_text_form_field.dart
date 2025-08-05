import 'package:flutter/material.dart';
import '../constant/text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final int maxLines;

  const AppTextFormField({
    super.key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: 'Enter $label'),
          onChanged: onChanged,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
