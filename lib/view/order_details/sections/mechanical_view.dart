import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/multi_select_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class MechanicalView extends StatelessWidget {
  const MechanicalView({super.key});

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
                  'Mechanical Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(
                  label: 'Heating Type',
                  category: 'HeatingType',
                  selectedOptions: order.heatingType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'heatingType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(
                  label: 'Electrical Type',
                  category: 'ElectricalType',
                  selectedOptions: order.electricalType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'electricalType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(
                  label: 'Water Type',
                  category: 'WaterType',
                  selectedOptions: order.waterType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'waterType', value: val),
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
