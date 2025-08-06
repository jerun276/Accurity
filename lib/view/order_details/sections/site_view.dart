import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class SiteView extends StatelessWidget {
  const SiteView({super.key});

  @override
  Widget build(BuildContext context) {
    // This list defines the options for the ToggleButtons widget.
    const waterSupplyOptions = ['Municipal', 'Well', 'Cistern', 'Dugout'];

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

                // --- MODIFIED: Water Supply Type as Toggle Buttons ---
                const Text(
                  'Water Supply Type',
                  style: AppTextStyles.fieldLabel,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ToggleButtons(
                    isSelected: waterSupplyOptions
                        .map((option) => option == order.waterSupplyType)
                        .toList(),
                    onPressed: (int index) {
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'waterSupplyType',
                          value: waterSupplyOptions[index],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    selectedColor: Colors.white,
                    selectedBorderColor: AppColors.accent,
                    fillColor: AppColors.accent,
                    children: waterSupplyOptions
                        .map(
                          (option) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(option),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // --- MODIFIED: Streetscape as a Searchable Dropdown ---
                SearchableDropdownFormField(
                  label: 'Streetscape',
                  value: order.streetscape,
                  category:
                      'Streetscape', // This category already exists in your seed data
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
