import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart'; // Import new widget
import '../bloc/order_details_bloc.dart';

class NeighbourhoodView extends StatelessWidget {
  const NeighbourhoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      buildWhen: (previous, current) => current is OrderDetailsLoaded,
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Neighbourhood Details',
                    style: AppTextStyles.sectionHeader.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Nature of District: Searchable Dropdown ---
                  SearchableDropdownFormField(
                    label: 'Nature of District',
                    value: order.natureOfDistrict,
                    category:
                        'NatureOfDistrict', // This MUST match the category in the DB
                    onChanged: (value) {
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'natureOfDistrict',
                          value: value,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Development Type: Searchable Dropdown ---
                  SearchableDropdownFormField(
                    label: 'Development Type',
                    value: order.developmentType,
                    category:
                        'DevelopmentType', // This MUST match the category in the DB
                    onChanged: (value) {
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'developmentType',
                          value: value,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- Gated Community: Switch ---
                  SwitchListTile(
                    title: const Text(
                      'Gated Community',
                      style: AppTextStyles.fieldLabel,
                    ),
                    value: order.isGatedCommunity,
                    activeColor: AppColors.accent,
                    onChanged: (value) {
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'isGatedCommunity',
                          value: value,
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Loading neighbourhood data...'));
      },
    );
  }
}
