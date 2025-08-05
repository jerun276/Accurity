import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/text_styles.dart';
import '../../data/models/order.model.dart';
import '../../data/repositories/order_repository.dart';
import '../order_details/order_details_view.dart';
import 'bloc/order_list_bloc.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderListBloc(
            orderRepository: RepositoryProvider.of<OrderRepository>(context),
          )..add(
            FetchAllOrders(),
          ), // Immediately fetch orders when the screen is created
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Inspections'),
          backgroundColor: AppColors.primary,
          actions: [
            // Logout button
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // TODO: Navigate back to Login screen
              },
            ),
          ],
        ),
        body: const OrderListContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // --- CREATE A NEW FAKE ORDER ---
            final repo = RepositoryProvider.of<OrderRepository>(context);
            // Create a new blank order and save it to get a localId
            final newOrder = await repo.saveOrder(
              Order(
                firmFileNumber: 'NEW-${DateTime.now().second}',
                address: 'New Inspection Address',
              ),
            );

            // Navigate to the details page for the newly created order
            if (context.mounted && newOrder.localId != null) {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderDetailsView(localOrderId: newOrder.localId!),
                    ),
                  )
                  .then((_) {
                    // After returning from details, refresh the list
                    context.read<OrderListBloc>().add(FetchAllOrders());
                  });
            }
          },
          backgroundColor: AppColors.accent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class OrderListContent extends StatelessWidget {
  const OrderListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderListError) {
          return Center(
            child: Text('Error: ${state.message}', style: AppTextStyles.hint),
          );
        }
        if (state is OrderListLoaded) {
          if (state.orders.isEmpty) {
            return const Center(
              child: Text(
                'No inspections found.\nPress the + button to create one.',
                textAlign: TextAlign.center,
                style: AppTextStyles.listItemSubtitle,
              ),
            );
          }
          // Display the list of orders
          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderListBloc>().add(FetchAllOrders());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      order.address ?? 'No Address',
                      style: AppTextStyles.listItemTitle,
                    ),
                    subtitle: Text(
                      'File: ${order.firmFileNumber ?? 'N/A'}\nStatus: ${order.syncStatus.name}',
                      style: AppTextStyles.listItemSubtitle,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mediumGrey,
                    ),
                    onTap: () {
                      // Navigate to details page and refresh list when returning
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsView(
                                localOrderId: order.localId!,
                              ),
                            ),
                          )
                          .then((_) {
                            context.read<OrderListBloc>().add(FetchAllOrders());
                          });
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink(); // For initial state
      },
    );
  }
}
