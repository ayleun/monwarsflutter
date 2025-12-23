import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesService {
  static Future<Map<String, String>> fetchPrayerTimes(
      double latitude, double longitude) async {
    try {
      String url =
          "http://api.aladhan.com/v1/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=$latitude&longitude=$longitude&method=2";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          final timings = data['data']['timings'];
          return {
            'Fajr': timings['Fajr'],
            'Dhuhr': timings['Dhuhr'],
            'Asr': timings['Asr'],
            'Maghrib': timings['Maghrib'],
            'Isha': timings['Isha'],
          };
        } else {
          debugPrint('Error: ${data['status']}');
        }
      }
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
    }

    // Return default prayer times for Senegal if fetch fails
    return {
      'Fajr': '05:30',
      'Dhuhr': '12:45',
      'Asr': '15:20',
      'Maghrib': '18:15',
      'Isha': '19:30',
    };
  }
}


