import 'package:shared_preferences/shared_preferences.dart';

class ReadingProgressService {
  static const String _keyLastPosition = 'lastPos';
  static const String _keyJuzzNumber = 'juzzNumber';
  static const String _keyLastReadInfo = 'last_read_info';
  static const String _keyLastReadImage = 'last_read_image';
  static const String _keyReadingProgress = 'reading_progress';
  static const String _keyLastPage = 'last_page';
  static const String _keyLastSourate = 'last_sourate';

  // Sauvegarder la position de lecture
  static Future<void> saveReadingPosition({
    required int lastPosition,
    required int juzzNumber,
    String? lastReadInfo,
    int? lastReadImage,
    int? readingProgress,
    int? lastPage,
    String? lastSourate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastPosition, lastPosition);
    await prefs.setInt(_keyJuzzNumber, juzzNumber);
    
    if (lastReadInfo != null) {
      await prefs.setString(_keyLastReadInfo, lastReadInfo);
    }
    if (lastReadImage != null) {
      await prefs.setInt(_keyLastReadImage, lastReadImage);
    }
    if (readingProgress != null) {
      await prefs.setInt(_keyReadingProgress, readingProgress);
    }
    if (lastPage != null) {
      await prefs.setInt(_keyLastPage, lastPage);
    }
    if (lastSourate != null) {
      await prefs.setString(_keyLastSourate, lastSourate);
    }
  }

  // Charger la position de lecture
  static Future<Map<String, dynamic>> loadReadingPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'lastPosition': prefs.getInt(_keyLastPosition) ?? 0,
      'juzzNumber': prefs.getInt(_keyJuzzNumber) ?? 1,
      'lastReadInfo': prefs.getString(_keyLastReadInfo) ?? '',
      'lastReadImage': prefs.getInt(_keyLastReadImage),
      'readingProgress': prefs.getInt(_keyReadingProgress) ?? 0,
      'lastPage': prefs.getInt(_keyLastPage) ?? 1,
      'lastSourate': prefs.getString(_keyLastSourate) ?? '',
    };
  }
}


