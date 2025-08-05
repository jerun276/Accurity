import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/text_styles.dart';
import '../bloc/order_details_bloc.dart';

class SiteView extends StatelessWidget {
  const SiteView({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder rebuilds the UI when the state changes.
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Site Details', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 24),

                // --- Example: Searchable Dropdown ---
                const Text('Configuration', style: AppTextStyles.fieldLabel),
                // Replace with your custom Searchable Dropdown widget
                DropdownButton<String>(
                  value: order.configuration,
                  hint: const Text('Select Configuration'),
                  isExpanded: true,
                  items:
                      [
                            'Typical',
                            'Atypical',
                          ] // This should come from a DropdownRepository
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    // Dispatch event to the parent BLoC
                    context.read<OrderDetailsBloc>().add(
                      OrderFieldChanged(
                        fieldName: 'configuration',
                        value: value,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // --- Example: Switch ---
                SwitchListTile(
                  title: const Text(
                    'Septic / Well',
                    style: AppTextStyles.fieldLabel,
                  ),
                  value: order.isSepticWell,
                  onChanged: (value) {
                    // Dispatch event to the parent BLoC
                    context.read<OrderDetailsBloc>().add(
                      OrderFieldChanged(
                        fieldName: 'isSepticWell',
                        value: value,
                      ),
                    );
                  },
                ),
                // Add all other fields for the Site section here...
              ],
            ),
          );
        }
        // Show a message if the state is not loaded, though the parent view handles this.
        return const Center(child: Text('Order not loaded.'));
      },
    );
  }
}
