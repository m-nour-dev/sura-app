
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchAndFilterBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchAndFilterBar> createState() => _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends State<SearchAndFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'search_hint_surah_number'.tr(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
