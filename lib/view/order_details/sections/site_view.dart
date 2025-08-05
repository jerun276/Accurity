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
                // --- Configuration ---
                SearchableDropdownFormField(
                  label: 'Configuration',
                  value: order.configuration,
                  category: 'Configuration', // MUST match category in DB
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'configuration', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Topography ---
                SearchableDropdownFormField(
                  label: 'Topography',
                  value: order.topography,
                  category: 'Topography', // MUST match category in DB
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'topography', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Water Supply Type ---
                SearchableDropdownFormField(
                  label: 'Water Supply Type',
                  value: order.waterSupplyType,
                  category: 'WaterSupplyType', // MUST match category in DB
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'waterSupplyType', value: val),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Septic / Well ---
                SwitchListTile(
                  title: const Text(
                    'Septic / Well',
                    style: AppTextStyles.fieldLabel,
                  ),
                  value: order.isSepticWell,
                  activeColor: AppColors.accent,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'isSepticWell', value: val),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // --- Streetscape ---
                CheckboxListFormField(
                  label: 'Streetscape',
                  allOptions: const [
                    'Paved',
                    'Gravel',
                    'Sidewalk',
                    'Curb',
                  ], // TODO: Fetch from DB
                  selectedOptions: order.streetscape,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'streetscape', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Site Influence ---
                SearchableDropdownFormField(
                  label: 'Site Influence',
                  value: order.siteInfluence,
                  category: 'SiteInfluence', // MUST match category in DB
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'siteInfluence', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Site Improvements ---
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

                // --- Driveway ---
                SearchableDropdownFormField(
                  label: 'Driveway',
                  value: order.driveway,
                  category: 'Driveway', // MUST match category in DB
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'driveway', value: val),
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
