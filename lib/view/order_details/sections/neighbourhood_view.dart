import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../bloc/order_details_bloc.dart';

/// A stateless widget that displays the form fields for the "Neighbourhood" section.
///
/// It listens to the parent [OrderDetailsBloc] and dispatches events
/// when the user interacts with the form fields.
class NeighbourhoodView extends StatelessWidget {
  const NeighbourhoodView({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder rebuilds the UI whenever the OrderDetailsState changes.
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      // We only build the UI when the state is OrderDetailsLoaded.
      buildWhen: (previous, current) => current is OrderDetailsLoaded,
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            // Use a Form widget if you plan to add field-level validation later
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
                  const Text(
                    'Nature of District',
                    style: AppTextStyles.fieldLabel,
                  ),
                  const SizedBox(height: 8),
                  // TODO: Replace with your custom Searchable Dropdown widget
                  DropdownButtonFormField<String>(
                    value: order.natureOfDistrict,
                    hint: const Text('Select Nature'),
                    isExpanded: true,
                    // These items should be fetched from the DatabaseRepository in a real scenario
                    items: ['Urban', 'Suburban', 'Rural']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      // Dispatch event to the parent BLoC on change
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'natureOfDistrict',
                          value: value,
                        ),
                      );
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 24),

                  // --- Development Type: Searchable Dropdown ---
                  const Text(
                    'Development Type',
                    style: AppTextStyles.fieldLabel,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: order.developmentType,
                    hint: const Text('Select Development Type'),
                    isExpanded: true,
                    // These items should be fetched from the DatabaseRepository
                    items: ['Typical', 'New', 'Mixed Use']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'developmentType',
                          value: value,
                        ),
                      );
                    },
                    decoration: const InputDecoration(),
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
        // This part should ideally not be reached because the parent view
        // handles the loading and error states. It's here as a fallback.
        return const Center(child: Text('Loading neighbourhood data...'));
      },
    );
  }
}
