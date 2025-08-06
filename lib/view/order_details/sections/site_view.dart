import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/checkbox_list_form_field.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class SiteView extends StatelessWidget {
  const SiteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      buildWhen: (previous, current) => current is OrderDetailsLoaded,
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Site Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                SearchableDropdownFormField(
                  label: 'Configuration',
                  value: order.configuration,
                  category: 'Configuration',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'configuration', value: val),
                  ),
                ),
                const SizedBox(height: 24),
                SearchableDropdownFormField(
                  label: 'Topography',
                  value: order.topography,
                  category: 'Topography',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'topography', value: val),
                  ),
                ),
                const SizedBox(height: 24),
                SearchableDropdownFormField(
                  label: 'Water Supply Type',
                  value: order.waterSupplyType,
                  category: 'WaterSupplyType',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'waterSupplyType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // The Septic/Well Switch has been removed.
                CheckboxListFormField(
                  label: 'Streetscape',
                  allOptions: const [
                    'Curbs',
                    'Lights',
                    'Sidewalks',
                    'Overhead Wires',
                    'Underground Wires',
                    'Open Ditch',
                  ],
                  selectedOptions: order.streetscape,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'streetscape', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                SearchableDropdownFormField(
                  label: 'Site Influence',
                  value: order.siteInfluence,
                  category: 'SiteInfluence',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'siteInfluence', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Site Improvements',
                  initialValue: order.siteImprovements,
                  maxLines: 4,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'siteImprovements',
                      value: val,
                    ),
                  ),
                ),

                SearchableDropdownFormField(
                  label: 'Driveway',
                  value: order.driveway,
                  category: 'Driveway',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'driveway', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- NEWLY ADDED FIELDS ---
                SearchableDropdownFormField(
                  label: 'Parking',
                  value: order.parking,
                  category: 'Parking',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'parking', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                SearchableDropdownFormField(
                  label: 'Occupancy',
                  value: order.occupancy,
                  category: 'Occupancy',
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'occupancy', value: val),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Order not loaded.'));
      },
    );
  }
}
