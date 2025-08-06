import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/multi_select_dropdown_form_field.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart';
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
                Text('Structural Details', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.accent)),
                const SizedBox(height: 24),
                
                SwitchListTile(
                  title: const Text('Built in Past 10 Years', style: AppTextStyles.fieldLabel),
                  value: order.builtInPast10Years,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'builtInPast10Years', value: val)),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),

                SearchableDropdownFormField(label: 'Property Type', value: order.propertyType, category: 'PropertyType', onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'propertyType', value: val))),
                const SizedBox(height: 24),
                SearchableDropdownFormField(label: 'Design Style', value: order.designStyle, category: 'DesignStyle', onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'designStyle', value: val))),
                const SizedBox(height: 24),
                SearchableDropdownFormField(label: 'Construction', value: order.construction, category: 'Construction', onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'construction', value: val))),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(label: 'Siding Type', category: 'SidingType', selectedOptions: order.sidingType, onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'sidingType', value: val))),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(label: 'Roof Type', category: 'RoofType', selectedOptions: order.roofType, onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'roofType', value: val))),
                const SizedBox(height: 24),

                MultiSelectDropdownFormField(label: 'Window Type', category: 'WindowType', selectedOptions: order.windowType, onChanged: (val) => context.read<OrderDetailsBloc>().add(OrderFieldChanged(fieldName: 'windowType', value: val))),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}