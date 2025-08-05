import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/database_repository.dart';
import '../bloc/dropdown_data_bloc.dart';
import '../constant/app_colors.dart';
import '../constant/text_styles.dart';

class SearchableDropdownFormField extends StatelessWidget {
  final String label;
  final String? value;
  final String category;
  final Function(String?) onChanged;
  const SearchableDropdownFormField({
    super.key,
    required this.label,
    this.value,
    required this.category,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // 1. Create the BLoC instance before showing the sheet,
            // using the current, valid context to find the repository.
            final dropdownBloc = DropdownDataBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(FetchDropdownData(category));
            showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      // 2. Use BlocProvider.value to provide the existing BLoC
                      //    to the new route created by the bottom sheet.
                      BlocProvider.value(
                        value: dropdownBloc,
                        child: _SearchableDropdownSheet(title: label),
                      ),
                )
                .then((result) {
                  // The `then` block is a safer place to handle the result
                  if (result != null) {
                    onChanged(result);
                  }
                })
                .whenComplete(() {
                  // 3. IMPORTANT: Close the BLoC when the sheet is dismissed
                  //    to prevent memory leaks.
                  dropdownBloc.close();
                });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.lightGrey, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? 'Select $label',
                  style: value != null
                      ? AppTextStyles.input
                      : AppTextStyles.hint,
                ),
                const Icon(Icons.arrow_drop_down, color: AppColors.mediumGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// The _SearchableDropdownSheet widget remains exactly the same.
class _SearchableDropdownSheet extends StatefulWidget {
  final String title;
  const _SearchableDropdownSheet({required this.title});
  @override
  State<_SearchableDropdownSheet> createState() =>
      __SearchableDropdownSheetState();
}

class __SearchableDropdownSheetState extends State<_SearchableDropdownSheet> {
  final _searchController = TextEditingController();
  String _query = '';
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (_, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                widget.title,
                style: AppTextStyles.sectionHeader.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<DropdownDataBloc, DropdownDataState>(
                  builder: (context, state) {
                    if (state is DropdownDataLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is DropdownDataLoaded) {
                      final filteredItems = state.items
                          .where(
                            (item) => item.value.toLowerCase().contains(
                              _query.toLowerCase(),
                            ),
                          )
                          .toList();
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return ListTile(
                            title: Text(item.value),
                            onTap: () {
                              Navigator.of(context).pop(item.value);
                            },
                          );
                        },
                      );
                    }
                    if (state is DropdownDataError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
