import 'package:flutter/material.dart';
import '../services/prayer_times_service.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String>? prayerTimes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Coordonnées du Sénégal par défaut
      final times = await PrayerTimesService.fetchPrayerTimes(14.4974, -14.4524);

      if (mounted) {
        setState(() {
          prayerTimes = times;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heures de Prière'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!,
              Colors.white,
            ],
          ),
        ),
        child: isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.green[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chargement des heures de prière...',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPrayerCard('Soubeu (Aube)', prayerTimes?['Fajr'] ?? '05:30', Icons.wb_sunny),
                    const SizedBox(height: 16),
                    _buildPrayerCard('TisBar (Midi)', prayerTimes?['Dhuhr'] ?? '12:45', Icons.wb_twilight),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Takussan (Après-midi)', prayerTimes?['Asr'] ?? '15:20', Icons.brightness_4),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Timis (Crépuscule)', prayerTimes?['Maghrib'] ?? '18:15', Icons.wb_twilight),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Guewe (Nuit)', prayerTimes?['Isha'] ?? '19:30', Icons.nightlight_round),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: NavigationHelper.shouldShowNavbar(context)
          ? AppBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) => NavigationHelper.navigateFromBottomNav(context, index),
            )
          : null,
    );
  }

  Widget _buildPrayerCard(String name, String time, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 48),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}









