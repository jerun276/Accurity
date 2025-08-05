import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../bloc/order_details_bloc.dart';

class BasementView extends StatelessWidget {
  const BasementView({super.key});

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
                  'Basement Details',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                AppTextFormField(
                  label: 'Basement Type',
                  initialValue: order.basementType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Basement Finish',
                  initialValue: order.basementFinish,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementFinish', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Foundation Type',
                  initialValue: order.foundationType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'foundationType', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Rooms',
                  initialValue: order.basementRooms,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'basementRooms', value: val),
                  ),
                ),
                AppTextFormField(
                  label: 'Features',
                  initialValue: order.basementFeatures,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementFeatures',
                      value: val,
                    ),
                  ),
                ),
                AppTextFormField(
                  label: 'Flooring',
                  initialValue: order.basementFlooring,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementFlooring',
                      value: val,
                    ),
                  ),
                ),
                AppTextFormField(
                  label: 'Ceiling Type',
                  initialValue: order.basementCeilingType,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'basementCeilingType',
                      value: val,
                    ),
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
