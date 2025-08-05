import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/app_text_form_field.dart';
import '../bloc/order_details_bloc.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final order = state.order;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                AppTextFormField(
                  label: 'Roof Notes',
                  initialValue: order.roofNotes,
                  maxLines: 4,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'roofNotes', value: val),
                  ),
                ),
                // windowNotes, kitchenNotes, bathNotes, furnaceNotes
                AppTextFormField(
                  label: 'Window Notes',
                  initialValue: order.windowNotes,
                  maxLines: 4,
                  onChanged: (val) => context.read<OrderDetailsBloc>().add(
                    OrderFieldChanged(fieldName: 'windowNotes', value: val),
                  ),
                ),
                // ... and so on for the rest of the note fields ...
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
