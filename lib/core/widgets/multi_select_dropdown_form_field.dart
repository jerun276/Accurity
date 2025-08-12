import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/database_repository.dart';
import '../bloc/dropdown_data_bloc.dart';
import '../constant/app_colors.dart';
import '../constant/text_styles.dart';

class MultiSelectDropdownFormField extends StatelessWidget {
  final String label;
  final String category;
  final List<String> selectedOptions;
  final Function(List<String>) onChanged;

  const MultiSelectDropdownFormField({
    super.key,
    required this.label,
    required this.category,
    required this.selectedOptions,
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

            showModalBottomSheet<List<String>>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: dropdownBloc,
                    child: _MultiSelectSheet(
                      title: label,
                      initialSelectedOptions: selectedOptions,
                    ),
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
                Expanded(
                  child: Text(
                    selectedOptions.isEmpty
                        ? 'Select $label'
                        : selectedOptions.join(', '),
                    style: selectedOptions.isNotEmpty
                        ? AppTextStyles.input
                        : AppTextStyles.hint,
                    overflow: TextOverflow.ellipsis,
                  ),
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

class _MultiSelectSheet extends StatefulWidget {
  final String title;
  final List<String> initialSelectedOptions;
  const _MultiSelectSheet({
    required this.title,
    required this.initialSelectedOptions,
  });

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  final _searchController = TextEditingController();
  final _customEntryController =
      TextEditingController();
  late final List<String> _currentSelections;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _currentSelections = List<String>.from(widget.initialSelectedOptions);
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

  void _addCustomValue() {
    final text = _customEntryController.text.trim();
    if (text.isNotEmpty && !_currentSelections.contains(text)) {
      setState(() {
        _currentSelections.add(text);
        _customEntryController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
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
                          return CheckboxListTile(
                            title: Text(item.value),
                            value: _currentSelections.contains(item.value),
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue == true) {
                                  _currentSelections.add(item.value);
                                } else {
                                  _currentSelections.remove(item.value);
                                }
                              });
                            },
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
                  labelText: 'Add a custom value',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addCustomValue,
                    color: AppColors.accent,
                  ),
                ),
                onSubmitted: (_) => _addCustomValue(),
              ),
              const SizedBox(height: 16),
              if (_currentSelections.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _currentSelections
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          onDeleted: () =>
                              setState(() => _currentSelections.remove(item)),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => Navigator.of(context).pop(_currentSelections),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }
}
