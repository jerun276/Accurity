import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/app_colors.dart';
import '../constant/text_styles.dart';

/// A reusable form field for picking a date and optionally a time.
class AppDateTimePicker extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final bool pickTime; // Set to false to only pick the date

  const AppDateTimePicker({
    super.key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.pickTime = true, // Default to picking both date and time
  });

  Future<void> _pickDateTime(BuildContext context) async {
    // Attempt to parse the initial value to set the picker's start date
    DateTime initialDate = DateTime.now();
    if (initialValue != null && initialValue!.isNotEmpty) {
      try {
        initialDate = DateTime.parse(initialValue!);
      } catch (e) {
        // Ignore parsing errors, just default to now
      }
    }

    // 1. Show the Date Picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return; // User canceled

    // 2. If pickTime is true, show the Time Picker
    if (pickTime && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime == null) return; // User canceled

      // Combine date and time and format it
      final finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final formattedString = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(finalDateTime);
      onChanged(formattedString);
    } else {
      // If only picking the date, format and return it
      final formattedString = DateFormat('yyyy-MM-dd').format(pickedDate);
      onChanged(formattedString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDateTime(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.lightGrey, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (initialValue != null && initialValue!.isNotEmpty)
                      ? initialValue!
                      : 'Select $label',
                  style: (initialValue != null && initialValue!.isNotEmpty)
                      ? AppTextStyles.input
                      : AppTextStyles.hint,
                ),
                const Icon(Icons.calendar_today, color: AppColors.mediumGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
