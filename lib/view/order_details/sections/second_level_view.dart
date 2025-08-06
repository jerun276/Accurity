import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/checkbox_list_form_field.dart';
import '../bloc/order_details_bloc.dart';

class SecondLevelView extends StatelessWidget {
  const SecondLevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Second Level Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Rooms',
                  initialValue: order.secondLevelRooms,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'secondLevelRooms',
                      value: val,
                    ),
                  ),
                ),

                CheckboxListFormField(
                  label: 'Features',
                  // This uses the same long list as the basement features
                  allOptions: const [
                    '9 foot ceilings',
                    'archways',
                    'automated blinds',
                    'barn doors',
                    'built in cabinets',
                    'built in esperesson machine',
                    'built in shelving',
                    'built-in microwave',
                    'built-in oven',
                    'built-in stove',
                    'catherderal ceiling',
                    'chair rails',
                    'closet',
                    'coffered ceiling',
                    'concreate counter tops',
                    'control 4',
                    'cove ceiling',
                    'crown molding',
                    'custom window shutters',
                    'decorative pillars',
                    'double sided fireplace',
                    'Electric fireplace',
                    'exposed beams',
                    'French doors',
                    'gas fireplace',
                    'glass cabinet doors',
                    'glass walls',
                    'heated floors',
                    'heated towl racks',
                    'integrated sound',
                    'laundry shoot',
                    'massage shower',
                    'networked',
                    'palladian window',
                    'pocket doors',
                    'pot lighting',
                    'round corner beads',
                    'self closing cabinets',
                    'skylight',
                    'solid core doors',
                    'solid surface bathroom counter tops',
                    'Solid surface kitchen and bathroom counter tops',
                    'solid surface kitchen counter tops',
                    'steam shower',
                    'stone wall',
                    'texured wall',
                    'transom window',
                    'tray ceiling',
                    'vault ceiling',
                    'wainscoting',
                    'walk-in closet',
                    'wall mounted faucets',
                    'waterfall island',
                    'wood fireplace',
                  ],
                  selectedOptions: order.secondLevelFeatures,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'secondLevelFeatures',
                      value: val,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Flooring',
                  initialValue: order.secondLevelFlooring,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'secondLevelFlooring',
                      value: val,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
