import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/text_styles.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../data/models/order.model.dart';
import '../../data/repositories/order_repository.dart';
import '../order_details/order_details_view.dart';
import 'bloc/order_list_bloc.dart';
import '../../core/widgets/sync_status_indicator.dart'; // Import the new widget


class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderListBloc(
        // THE FIX IS HERE: Provide both required services.
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
        authService: RepositoryProvider.of<SupabaseAuthService>(context),
      )..add(FetchAllOrders()), // Immediately fetch and sync orders on load
      child: const OrderListPage(),
    );
  }
}

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inspections'),
        actions: [
          const SyncStatusIndicator(), 
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Dispatch the logout event to the BLoC, which now handles
              // clearing local data and signing out.
              context.read<OrderListBloc>().add(LogoutButtonPressed());
            },
          ),
        ],
      ),
      body: const OrderListContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final repo = RepositoryProvider.of<OrderRepository>(context);
          final newOrder = await repo.saveOrder(
            Order(
              firmFileNumber: 'NEW-${DateTime.now().millisecond}',
              address: 'New Inspection Address',
            ),
          );

          if (context.mounted && newOrder.localId != null) {
            await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) =>
                    OrderDetailsView(localOrderId: newOrder.localId!),
              ),
            );

            // After returning, refresh the list to show the newly created order.
            // This is still useful even with sync-on-load.
            if (context.mounted) {
              context.read<OrderListBloc>().add(FetchAllOrders());
            }
          }
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${state.message}',
                textAlign: TextAlign.center,
                style: AppTextStyles.hint,
              ),
            ),
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
          // The RefreshIndicator allows the user to manually trigger a sync from the server.
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
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              OrderDetailsView(localOrderId: order.localId!),
                        ),
                      );
                      // After editing, refresh the list.
                      if (context.mounted) {
                        context.read<OrderListBloc>().add(FetchAllOrders());
                      }
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink(); // For the initial state
      },
    );
  }
}
