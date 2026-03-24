import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final customIbadahListProvider = StateNotifierProvider<CustomIbadahListNotifier, List<String>>((ref) {
  return CustomIbadahListNotifier();
});

class CustomIbadahListNotifier extends StateNotifier<List<String>> {
  CustomIbadahListNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('custom_ibadah_list') ?? [];
    state = list;
  }

  Future<void> add(String name) async {
    if (state.contains(name)) return;
    final newState = [...state, name];
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_ibadah_list', newState);
  }

  Future<void> remove(String name) async {
    final newState = state.where((e) => e != name).toList();
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_ibadah_list', newState);
  }
}
