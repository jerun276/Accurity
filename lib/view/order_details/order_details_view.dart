import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/text_styles.dart';
import '../../data/repositories/order_repository.dart';
import 'bloc/order_details_bloc.dart';
import 'sections/neighbourhood_view.dart';
import 'sections/site_view.dart';
// Import all other section views here...

class OrderDetailsView extends StatelessWidget {
  final int localOrderId;

  const OrderDetailsView({super.key, required this.localOrderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc(
        // RepositoryProvider gives us access to the repository instance
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
      )..add(LoadOrderDetails(localOrderId)), // Load the order immediately
      child: const OrderDetailsPage(),
    );
  }
}

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // This list defines the order and titles of your sections.
  final List<String> _sectionTitles = [
    'Order Details',
    'Neighbourhood',
    'Site',
    'Structural Details',
    'Mechanical',
    'Basement',
    'Main Level',
    'Second Level',
    'Third Level',
    'Fourth Level',
    'Component Age',
    'Notes',
    'Sketch',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Details'),
        backgroundColor: AppColors.accent,
      ),
      body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading || state is OrderDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderDetailsError) {
            return Center(child: Text(state.message));
          }
          if (state is OrderDetailsLoaded) {
            // Main layout for tablet/desktop
            return Row(
              children: [
                // --- Navigation Rail ---
                _buildNavigationRail(),

                // --- Content Area ---
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: const [
                      // IMPORTANT: Add all your section views here in the correct order.
                      Center(child: Text('Order Details View - To Be Built')),
                      NeighbourhoodView(),
                      SiteView(),
                      Center(child: Text('Structural View - To Be Built')),
                      Center(child: Text('Mechanical View - To Be Built')),
                      // ... and so on
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNavigationRail() {
    return Material(
      elevation: 4.0,
      child: Container(
        width: 200,
        color: AppColors.surface,
        child: ListView.builder(
          itemCount: _sectionTitles.length,
          itemBuilder: (context, index) {
            final isSelected = index == _currentPageIndex;
            return ListTile(
              title: Text(
                _sectionTitles[index],
                style: isSelected
                    ? AppTextStyles.fieldLabel.copyWith(color: AppColors.accent)
                    : AppTextStyles.fieldLabel.copyWith(
                        color: AppColors.textSecondary,
                      ),
              ),
              selected: isSelected,
              selectedTileColor: AppColors.accent.withOpacity(0.1),
              onTap: () {
                setState(() {
                  _currentPageIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            );
          },
        ),
      ),
    );
  }
}
