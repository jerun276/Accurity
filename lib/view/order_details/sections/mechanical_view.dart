import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/checkbox_list_form_field.dart';
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

                CheckboxListFormField(
                  label: 'Heating Type',
                  allOptions: const [
                    'Forced Air',
                    'Basedboard',
                    'Boiler',
                    'Radiant In-floor',
                    'Radiator',
                    'Hydronic',
                    'Heat Pump',
                    'Gas',
                    'Electric',
                    'Oil',
                    'Geo Thermal',
                    'X2',
                    'X3',
                    'HRV',
                    'Central Air',
                    'Humidifier',
                    'Air Cleaner',
                  ],
                  selectedOptions: order.heatingType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'heatingType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                CheckboxListFormField(
                  label: 'Electrical Type',
                  allOptions: const [
                    '60',
                    '100',
                    '125',
                    '150',
                    '200',
                    '300',
                    '400',
                    'Breaker',
                    'Fuses',
                    'X2',
                    'X3',
                    'X4',
                    'X5',
                    'Solar',
                    'Backup Generator',
                    'Secuirty',
                    'Networked',
                    'Intercom',
                    'Video Surveilance',
                  ],
                  selectedOptions: order.electricalType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'electricalType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                CheckboxListFormField(
                  label: 'Water Type',
                  allOptions: const [
                    'Tankless',
                    '40',
                    '50',
                    '60',
                    '80',
                    '115',
                    '151',
                    '189',
                    '227',
                    'Gallons',
                    'liters',
                  ],
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
