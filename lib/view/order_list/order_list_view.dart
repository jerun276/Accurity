import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/text_styles.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../data/models/order.model.dart';
import '../../data/repositories/order_repository.dart';
import '../order_details/order_details_view.dart';
import 'bloc/order_list_bloc.dart';
import '../../core/widgets/sync_status_indicator.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderListBloc(
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
        authService: RepositoryProvider.of<SupabaseAuthService>(context),
      )..add(SyncOrdersFromServer()),
      child: const OrderListPage(),
    );
  }
}

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Inspections',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.textOnPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primary,
        elevation: 4.0,
        shadowColor: AppColors.primary.withOpacity(0.5),
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
        actions: [
          const SyncStatusIndicator(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () {
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

            if (context.mounted) {
              context.read<OrderListBloc>().add(FetchLocalOrders());
            }
          }
        },
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 8.0,
        tooltip: 'Add new inspection',
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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

          final bool isRefreshDisabled = state.hasOfflineChanges;

          if (isRefreshDisabled) {
            Future.delayed(Duration.zero, () {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Manual sync is required. Please tap the cloud icon to upload your offline changes.',
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            });
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: isRefreshDisabled
                ? () async {}
                : () async {
                    context.read<OrderListBloc>().add(SyncOrdersFromServer());
                  },
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  color: AppColors.surface,
                  elevation: 6.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      order.address ?? 'No Address',
                      style: AppTextStyles.listItemTitle.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      'File: ${order.firmFileNumber ?? 'N/A'}\nStatus: ${order.syncStatus.name}',
                      style: AppTextStyles.listItemSubtitle,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mediumGrey,
                      size: 16,
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              OrderDetailsView(localOrderId: order.localId!),
                        ),
                      );
                      if (context.mounted) {
                        context.read<OrderListBloc>().add(FetchLocalOrders());
                      }
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
