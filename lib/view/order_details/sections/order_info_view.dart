import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../../../core/widgets/searchable_dropdown_form_field.dart';
import '../bloc/order_details_bloc.dart';

class OrderInfoView extends StatelessWidget {
  const OrderInfoView({super.key});

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
                  'Order Information',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Client File Number ---
                AppTextFormField(
                  label: 'Client File Number',
                  initialValue: order.clientFileNumber,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(
                      fieldName: 'clientFileNumber',
                      value: val,
                    ),
                  ),
                ),

                // --- Firm File Number ---
                AppTextFormField(
                  label: 'Firm File Number',
                  initialValue: order.firmFileNumber,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'firmFileNumber', value: val),
                  ),
                ),

                // --- Address ---
                AppTextFormField(
                  label: 'Address',
                  initialValue: order.address,
                  maxLines: 3,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'address', value: val),
                  ),
                ),

                // --- Applicant Name ---
                AppTextFormField(
                  label: 'Applicant Name',
                  initialValue: order.applicantName,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'applicantName', value: val),
                  ),
                ),

                // --- Appointment Date ---
                const Text('Appointment', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(text: order.appointment),
                  decoration: const InputDecoration(
                    hintText: 'Select Appointment Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    // TODO: Implement Date Picker logic
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      // Format the date and dispatch the event
                      final formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked);
                      context.read<OrderDetailsBloc>().add(
                        OrderFieldChanged(
                          fieldName: 'appointment',
                          value: formattedDate,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // --- Client ---
                AppTextFormField(
                  label: 'Client',
                  initialValue: order.client,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'client', value: val),
                  ),
                ),

                // --- Lender ---
                AppTextFormField(
                  label: 'Lender',
                  initialValue: order.lender,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'lender', value: val),
                  ),
                ),

                // --- Service Type ---
                SearchableDropdownFormField(
                  label: 'Service Type',
                  value: order.serviceType,
                  category: 'ServiceType', // MUST match category in DB seeding
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'serviceType', value: val),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Loan Type ---
                SearchableDropdownFormField(
                  label: 'Loan Type',
                  value: order.loanType,
                  category: 'LoanType', // MUST match category in DB seeding
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'loanType', value: val),
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
