import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';

class SketchView extends StatelessWidget {
  const SketchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.draw, size: 60, color: AppColors.mediumGrey),
            const SizedBox(height: 16),
            Text(
              'Sketch Pad',
              style: AppTextStyles.sectionHeader.copyWith(
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature will be implemented using a drawing package.\n(e.g., `painter` or `syncfusion_flutter_signaturepad`)',
              textAlign: TextAlign.center,
              style: AppTextStyles.listItemSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
