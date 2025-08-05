import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/text_styles.dart';

class CheckboxListFormField extends StatefulWidget {
  final String label;
  final List<String> allOptions;
  final List<String> selectedOptions;
  final Function(List<String>) onChanged;

  const CheckboxListFormField({
    super.key,
    required this.label,
    required this.allOptions,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  State<CheckboxListFormField> createState() => _CheckboxListFormFieldState();
}

class _CheckboxListFormFieldState extends State<CheckboxListFormField> {
  late List<String> _currentlySelected;

  @override
  void initState() {
    super.initState();
    // Initialize the local state with the options passed from the parent
    _currentlySelected = List<String>.from(widget.selectedOptions);
  }

  // This is important to update the widget if the parent state changes
  @override
  void didUpdateWidget(covariant CheckboxListFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedOptions != oldWidget.selectedOptions) {
      _currentlySelected = List<String>.from(widget.selectedOptions);
    }
  }

  void _onCheckboxChanged(bool? newValue, String option) {
    setState(() {
      if (newValue == true) {
        _currentlySelected.add(option);
      } else {
        _currentlySelected.remove(option);
      }
    });
    // Call the callback to notify the parent BLoC of the change
    widget.onChanged(_currentlySelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.lightGrey, width: 1.0),
          ),
          child: Column(
            // Create a CheckboxListTile for each available option
            children: widget.allOptions.map((option) {
              return CheckboxListTile(
                title: Text(option),
                value: _currentlySelected.contains(option),
                onChanged: (bool? newValue) {
                  _onCheckboxChanged(newValue, option);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.accent,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
