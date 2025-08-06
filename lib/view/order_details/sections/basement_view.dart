import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/multi_select_dropdown_form_field.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class BasementView extends StatelessWidget {
  const BasementView({super.key});

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
                  'Basement Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                SearchableDropdownFormField(
                  label: 'Basement Type',
                  value: order.basementType,
                  category: 'BasementType',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementType', value: val),
                  ),
                ),
                const SizedBox(height: 24),
                SearchableDropdownFormField(
                  label: 'Basement Finish',
                  value: order.basementFinish,
                  category: 'BasementFinish',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementFinish', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(
                  label: 'Foundation Type',
                  category: 'FoundationType',
                  selectedOptions: order.foundationType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'foundationType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Rooms',
                  initialValue: order.basementRooms,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementRooms', value: val),
                  ),
                ),

                MultiSelectDropdownFormField(
                  label: 'Features',
                  category: 'BasementFeatures',
                  selectedOptions: order.basementFeatures,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementFeatures',
                      value: val,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Flooring',
                  initialValue: order.basementFlooring,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementFlooring',
                      value: val,
                    ),
                  ),
                ),

                MultiSelectDropdownFormField(
                  label: 'Ceiling Type',
                  category: 'BasementCeilingType',
                  selectedOptions: order.basementCeilingType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementCeilingType',
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
