import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double direction = 65.0; // Direction Qibla en degrés (vers la Mecque depuis le Sénégal)
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Simuler l'initialisation de la boussole
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direction Qibla'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isInitialized)
                const CircularProgressIndicator()
              else
                _buildCompass(),
              const SizedBox(height: 48),
              _buildDirectionInfo(),
              const SizedBox(height: 32),
              _buildInstructions(),
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

  Widget _buildCompass() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green[700]!, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle interne
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          // Indicateur Qibla
          Transform.rotate(
            angle: (direction * math.pi) / 180,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Icon(
                Icons.explore,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          // Point central
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Direction: ${direction.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Vers la Mecque',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700], size: 32),
              const SizedBox(height: 12),
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Utilisez la boussole pour vous orienter vers la direction indiquée.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









