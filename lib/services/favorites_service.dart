import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _keyFavorites = 'favorites_list';

  static Future<List<Map<String, dynamic>>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFavorites);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveFavorites(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFavorites, jsonEncode(items));
  }

  static Future<void> addFavorite({
    required int juzzNumber,
    required int pageNumber,
    required String title,
    required String subtitle,
  }) async {
    final items = await loadFavorites();
    final exists = items.any((e) => e['juzzNumber'] == juzzNumber && e['pageNumber'] == pageNumber);
    if (!exists) {
      items.insert(0, {
        'juzzNumber': juzzNumber,
        'pageNumber': pageNumber,
        'title': title,
        'subtitle': subtitle,
        'createdAt': DateTime.now().toIso8601String(),
      });
      await saveFavorites(items);
    }
  }

  static Future<void> removeFavorite(int juzzNumber, int pageNumber) async {
    final items = await loadFavorites();
    items.removeWhere((e) => e['juzzNumber'] == juzzNumber && e['pageNumber'] == pageNumber);
    await saveFavorites(items);
  }

  static Future<bool> isFavorite(int juzzNumber, int pageNumber) async {
    final items = await loadFavorites();
    return items.any((e) => e['juzzNumber'] == juzzNumber && e['pageNumber'] == pageNumber);
  }
}


