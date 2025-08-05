import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../bloc/order_details_bloc.dart';

class StructuralView extends StatelessWidget {
  const StructuralView({super.key});

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
                  'Structural Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                SwitchListTile(
                  title: const Text(
                    'Built in Past 10 Years',
                    style: AppTextStyles.fieldLabel,
                  ),
                  value: order.builtInPast10Years,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'builtInPast10Years',
                      value: val,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // TODO: Replace with a real Dropdown/Searchable widget fetching from DB
                AppTextFormField(
                  label: 'Property Type',
                  initialValue: order.propertyType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'propertyType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Design Style',
                  initialValue: order.designStyle,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'designStyle', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Construction',
                  initialValue: order.construction,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'construction', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Siding Type',
                  initialValue: order.sidingType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'sidingType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Roof Type',
                  initialValue: order.roofType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'roofType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Window Type',
                  initialValue: order.windowType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'windowType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Parking',
                  initialValue: order.parking,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'parking', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Garage',
                  initialValue: order.garage,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'garage', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Occupancy',
                  initialValue: order.occupancy,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'occupancy', value: val),
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
