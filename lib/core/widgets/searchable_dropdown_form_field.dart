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
            final dropdownBloc = DropdownDataBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(FetchDropdownData(category));
            showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      BlocProvider.value(
                        value: dropdownBloc,
                        child: _SearchableDropdownSheet(title: label),
                      ),
                )
                .then((result) {
                  if (result != null) {
                    onChanged(result);
                  }
                })
                .whenComplete(() {
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

class _SearchableDropdownSheet extends StatefulWidget {
  final String title;
  const _SearchableDropdownSheet({required this.title});

  @override
  State<_SearchableDropdownSheet> createState() =>
      __SearchableDropdownSheetState();
}

class __SearchableDropdownSheetState extends State<_SearchableDropdownSheet> {
  final _searchController = TextEditingController();
  final _customEntryController =
      TextEditingController(); 
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customEntryController.dispose();
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
                  hintText: 'Search existing options...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<DropdownDataBloc, DropdownDataState>(
                  builder: (context, state) {
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
                            onTap: () => Navigator.of(context).pop(item.value),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              const Divider(height: 24),
              TextField(
                controller: _customEntryController,
                decoration: InputDecoration(
                  labelText: 'Or enter a custom value',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.accent,
                    onPressed: () {
                      final text = _customEntryController.text.trim();
                      if (text.isNotEmpty) {
                        Navigator.of(context).pop(text);
                      }
                    },
                  ),
                ),
                onSubmitted: (text) {
                  final trimmedText = text.trim();
                  if (trimmedText.isNotEmpty) {
                    Navigator.of(context).pop(trimmedText);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
