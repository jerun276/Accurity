import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/services/photo_service.dart';
import '../../../data/repositories/order_repository.dart';
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
    return DefaultTabController(
      length: _sectionTitles.length,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit Inspection?'),
              content: const Text(
                'All changes have been saved automatically. Do you want to go back to the order list?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
              builder: (context, state) {
                if (state is OrderDetailsLoaded) {
                  return Text(
                    state.order.address ?? 'Inspection Details',
                    overflow: TextOverflow.ellipsis,
                  );
                }
                return const Text('Inspection Details');
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.accent,
              labelStyle: AppTextStyles.button.copyWith(fontSize: 14),
              tabs: _sectionTitles.map((title) => Tab(text: title)).toList(),
            ),
          ),
          body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
              if (state is OrderDetailsLoading ||
                  state is OrderDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
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
