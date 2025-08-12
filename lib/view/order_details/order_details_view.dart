import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/services/photo_service.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../core/widgets/sync_status_indicator.dart';
import '../../../core/services/sync_service.dart';
import 'bloc/order_details_bloc.dart';
import 'sections/basement_view.dart';
import 'sections/component_age_view.dart';
import 'sections/fourth_level_view.dart';
import 'sections/main_level_view.dart';
import 'sections/mechanical_view.dart';
import 'sections/neighbourhood_view.dart';
import 'sections/notes_view.dart';
import 'sections/order_info_view.dart';
import 'sections/photos_view.dart';
import 'sections/second_level_view.dart';
import 'sections/site_view.dart';
import 'sections/sketch_view.dart';
import 'sections/structural_view.dart';
import 'sections/third_level_view.dart';

class OrderDetailsView extends StatelessWidget {
  final int localOrderId;

  const OrderDetailsView({super.key, required this.localOrderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc(
        orderRepository: context.read<OrderRepository>(),
        photoService: context.read<PhotoService>(),
      )..add(LoadOrderDetails(localOrderId)),
      child: const OrderDetailsPage(),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  static const List<String> _sectionTitles = [
    'Order Info',
    'Neighbourhood',
    'Site',
    'Structural',
    'Mechanical',
    'Basement',
    'Main Level',
    '2nd Level',
    '3rd Level',
    '4th Level',
    'Component Age',
    'Notes',
    'Photos',
    'Sketch',
  ];

  static const List<Widget> _sectionViews = [
    OrderInfoView(),
    NeighbourhoodView(),
    SiteView(),
    StructuralView(),
    MechanicalView(),
    BasementView(),
    MainLevelView(),
    SecondLevelView(),
    ThirdLevelView(),
    FourthLevelView(),
    ComponentAgeView(),
    NotesView(),
    PhotosView(),
    SketchView(),
  ];

  @override
  Widget build(BuildContext context) {
    final syncService = context.read<SyncService>();

    return DefaultTabController(
      length: _sectionTitles.length,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              backgroundColor: AppColors.surface,
              title: Text(
                'Exit Inspection?',
                style: AppTextStyles.listItemTitle.copyWith(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                'All changes have been saved automatically. Do you want to go back to the order list?',
                style: AppTextStyles.listItemSubtitle,
              ),
              actions: [
                SyncStatusIndicator(),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Stay',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    syncService.syncUnsyncedOrders();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Exit & Sync',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.accent,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 4.0,
            shadowColor: AppColors.primary.withOpacity(0.5),
            iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
            title: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
              builder: (context, state) {
                if (state is OrderDetailsLoaded) {
                  return Text(
                    state.order.address ?? 'Inspection Details',
                    style: AppTextStyles.sectionHeader.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 20, // Slightly smaller to fit with tabs
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                }
                return const Text(
                  'Inspection Details',
                  style: AppTextStyles.sectionHeader,
                );
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.accent,
              labelColor:
                  AppColors.textOnPrimary, // Color of the selected tab label
              unselectedLabelColor: AppColors.textOnPrimary.withOpacity(
                0.7,
              ), // Color of unselected labels
              labelStyle: AppTextStyles.listItemSubtitle.copyWith(
                fontWeight: FontWeight.w600, // Make the labels semi-bold
                fontSize: 14,
              ),
              tabs: _sectionTitles.map((title) => Tab(text: title)).toList(),
            ),
          ),
          body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
              if (state is OrderDetailsLoading ||
                  state is OrderDetailsInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (state is OrderDetailsError) {
                return Center(child: Text(state.message));
              }
              if (state is OrderDetailsLoaded) {
                return const TabBarView(children: _sectionViews);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
