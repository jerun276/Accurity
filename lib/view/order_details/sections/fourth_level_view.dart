import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/multi_select_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class FourthLevelView extends StatelessWidget {
  const FourthLevelView({super.key});

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
                  'Fourth Level Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Rooms',
                  initialValue: order.fourthLevelRooms,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'fourthLevelRooms',
                      value: val,
                    ),
                  ),
                ),

                MultiSelectDropdownFormField(
                  label: 'Features',
                  category: 'BasementFeatures', // Reusing the same feature list
                  selectedOptions: order.fourthLevelFeatures,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'fourthLevelFeatures',
                      value: val,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Flooring',
                  initialValue: order.fourthLevelFlooring,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'fourthLevelFlooring',
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
