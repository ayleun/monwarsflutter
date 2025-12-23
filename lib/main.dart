import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'screens/prayer_times_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/juzz_list_screen.dart';
import 'screens/sourate_list_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tasbih_screen.dart';
import 'services/reading_progress_service.dart';
import 'services/prayer_times_service.dart';
import 'services/theme_service.dart';
import 'widgets/app_bottom_navbar.dart';
import 'utils/navigation_helper.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MonWarsApp(),
    ),
  );
}

// Create a RouteObserver instance
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MonWarsApp extends StatelessWidget {
  const MonWarsApp({super.key});

  // Theme clair
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  // Theme sombre
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
    return MaterialApp(
      title: 'CORAN Warsh',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeService.themeMode,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      routes: {
        '/': (context) => const MonWarsHomePage(),
        '/prayer-times': (context) => const PrayerTimesScreen(),
        '/qibla': (context) => const QiblaScreen(),
        '/juzz-list': (context) => const JuzzListScreen(),
        '/sourate-list': (context) => const SourateListScreen(),
        '/reading': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ReadingScreen(
            juzzNumber: args['juzzNumber'],
            lastPosition: args['lastPosition'] ?? 0,
            sourateDescription: args['sourateDescription'],
          );
        },
        '/favorites': (context) => const FavoritesScreen(),
        '/settings': (context) => const SettingsScreen(),
            '/tasbih': (context) => const TasbihScreen(),
          },
        );
      },
    );
  }
}

class MonWarsHomePage extends StatefulWidget {
  const MonWarsHomePage({super.key});

  @override
  State<MonWarsHomePage> createState() => _MonWarsHomePageState();
}

class _MonWarsHomePageState extends State<MonWarsHomePage> with TickerProviderStateMixin, RouteAware {
  Map<String, dynamic>? lastReadData;
  bool isLoadingLastRead = true;
  Map<String, String>? prayerTimes;
  String? nextPrayerName;
  String? nextPrayerTime;
  String timeRemaining = '';
  Timer? _prayerTimer;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _bounceController.repeat(reverse: true);
    
    _loadLastRead();
    _loadPrayerTimes();
    _startPrayerTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _prayerTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and this route shows up
    // Reload last read data when returning to home page
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final data = await ReadingProgressService.loadReadingPosition();
    setState(() {
      lastReadData = data;
      isLoadingLastRead = false;
    });
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final times = await PrayerTimesService.fetchPrayerTimes(14.4974, -14.4524);
      if (mounted) {
        setState(() {
          prayerTimes = times;
        });
        _calculateNextPrayer();
      }
    } catch (e) {
      // Utiliser les heures par défaut en cas d'erreur
      setState(() {
        prayerTimes = {
          'Fajr': '05:30',
          'Dhuhr': '12:45',
          'Asr': '15:20',
          'Maghrib': '18:15',
          'Isha': '19:30',
        };
      });
      _calculateNextPrayer();
    }
  }

  void _calculateNextPrayer() {
    if (prayerTimes == null) return;

    final now = DateTime.now();
    
    // Mapping des prières avec leurs heures
    final prayers = [
      {'name': 'Fajr', 'time': prayerTimes!['Fajr']!, 'label': 'Fajr'},
      {'name': 'Dhuhr', 'time': prayerTimes!['Dhuhr']!, 'label': 'Dhuhr'},
      {'name': 'Asr', 'time': prayerTimes!['Asr']!, 'label': 'Asr'},
      {'name': 'Maghrib', 'time': prayerTimes!['Maghrib']!, 'label': 'Maghrib'},
      {'name': 'Isha', 'time': prayerTimes!['Isha']!, 'label': 'Isha'},
    ];

    // Trouver la prochaine prière
    String? nextPrayer;
    String? nextTime;
    
    for (var prayer in prayers) {
      final prayerTime = _parseTime(prayer['time']!);
      if (prayerTime != null) {
        final prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          prayerTime.hour,
          prayerTime.minute,
        );
        
        // Si l'heure de prière est après maintenant, c'est la prochaine
        if (prayerDateTime.isAfter(now)) {
          nextPrayer = prayer['label'];
          nextTime = prayer['time'];
          break;
        }
      }
    }

    // Si aucune prière n'est trouvée aujourd'hui, prendre Fajr de demain
    if (nextPrayer == null && prayers.isNotEmpty) {
      nextPrayer = prayers[0]['label'];
      nextTime = prayers[0]['time'];
    }

    setState(() {
      nextPrayerName = nextPrayer;
      nextPrayerTime = nextTime;
    });
    
    _updateTimeRemaining();
  }

  TimeOfDay? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  void _updateTimeRemaining() {
    if (nextPrayerTime == null) {
      setState(() {
        timeRemaining = '';
      });
      return;
    }

    final now = DateTime.now();
    final prayerTime = _parseTime(nextPrayerTime!);
    
    if (prayerTime == null) {
      setState(() {
        timeRemaining = '';
      });
      return;
    }

    var prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      prayerTime.hour,
      prayerTime.minute,
    );

    // Si l'heure de prière est passée, prendre celle de demain
    if (prayerDateTime.isBefore(now)) {
      prayerDateTime = prayerDateTime.add(const Duration(days: 1));
    }

    final difference = prayerDateTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    setState(() {
      if (hours > 0) {
        timeRemaining = '${hours}h ${minutes}m';
      } else if (minutes > 0) {
        timeRemaining = '${minutes}m ${seconds}s';
      } else {
        timeRemaining = '${seconds}s';
      }
    });
  }

  void _startPrayerTimer() {
    _prayerTimer?.cancel();
    _prayerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateTimeRemaining();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5DC),
      body: SafeArea(
        bottom: false, // Allow bottom nav to handle bottom padding
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomPadding = NavigationHelper.shouldShowNavbar(context) 
                ? MediaQuery.of(context).padding.bottom + 100.0 
                : MediaQuery.of(context).padding.bottom + 20.0;
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: bottomPadding,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec animations
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildHeader(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Section principale avec animations
              _buildMainCards(),
              const SizedBox(height: 24),
            ],
          ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationHelper.shouldShowNavbar(context)
          ? AppBottomNavBar(
              currentIndex: NavigationHelper.getCurrentIndex(context),
              onTap: (index) => NavigationHelper.navigateFromBottomNav(context, index),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
                      colors: [
            Colors.green[600]!,
                        Colors.green[700]!,
            Colors.green[800]!,
                      ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
                    ),
        ],
                  ),
                  child: Stack(
                    children: [
          // Effet de lumière en arrière-plan
                      Positioned(
            top: -50,
            right: -50,
                          child: Container(
              width: 150,
              height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                            ),
                            child: const Icon(
                              Icons.mosque_rounded,
                              color: Colors.white,
                        size: 32,
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text(
                                          'CORAN Warsh',
                                          style: TextStyle(
                                            color: Colors.white,
                              fontSize: 24,
                                            fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                                          ),
                                        ),
                          const SizedBox(height: 4),
                                        Text(
                                          'Saint Coran',
                                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _bounceAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _bounceAnimation.value,
                                        child: Container(
                            padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                                          ),
                            child: const Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                                ),
                                child: const Text(
                                  'القرآن الكريم',
                                  textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                                  style: TextStyle(
                      fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                if (nextPrayerName != null && nextPrayerTime != null) ...[
                  const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.4),
                        width: 1.5,
                      ),
                                ),
                                child: Row(
                                  children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prochaine prière: $nextPrayerName',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    nextPrayerTime!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (timeRemaining.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Dans $timeRemaining',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                  ],
                              ),
                            ],
                          ),
                        ),
                      ],
                        ),
                      ),
                    ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dernière lecture avec animation
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildLastReadCard(),
          ),
        ),
        const SizedBox(height: 16),
        
        // Grille de cartes rapides
        _buildQuickAccessGrid(),
        const SizedBox(height: 16),
        
        // Juzz List Card
        _buildJuzzListCard(),
        const SizedBox(height: 16),
        
        // Sourate List Card
        _buildSourateListCard(),
      ],
    );
  }

  Widget _buildLastReadCard() {
    if (isLoadingLastRead) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.green[800]!],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final lastReadInfo = lastReadData?['lastReadInfo'] ?? 'Aucune lecture';
    final progress = (lastReadData?['readingProgress'] ?? 0).toDouble() / 100;
    final juzzNumber = lastReadData?['juzzNumber'] ?? 1;
    final lastPosition = lastReadData?['lastPosition'] ?? 0;
    final lastSourate = lastReadData?['lastSourate'] ?? '';
    final lastPage = lastReadData?['lastPage'] ?? (lastPosition + 1);

    return InkWell(
      onTap: () {
        if (lastReadInfo != 'Aucune lecture') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingScreen(
                juzzNumber: juzzNumber,
                lastPosition: lastPosition,
                sourateDescription: lastSourate,
              ),
            ),
          ).then((_) {
            // Reload last read when returning from reading screen
            _loadLastRead();
          });
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.green[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'DERNIÈRE LECTURE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Affichage de l'image de la dernière page
            if (lastReadInfo != 'Aucune lecture')
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Image de la page
                    Image.asset(
                      'images/j${juzzNumber}_${lastPage}.webp',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.1),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image non disponible',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Overlay avec informations
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lastReadInfo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (lastSourate.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                lastSourate,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lastReadInfo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (lastSourate.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      lastSourate,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progression: ${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                if (lastReadInfo != 'Aucune lecture')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continuer',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, color: Colors.green, size: 18),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildAnimatedCard(
            'Prière',
            Icons.schedule_rounded,
            Colors.orange[600]!,
            () => Navigator.pushNamed(context, '/prayer-times'),
            delay: 200,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnimatedCard(
            'Qibla',
            Icons.explore_rounded,
            Colors.blue[600]!,
            () => Navigator.pushNamed(context, '/qibla'),
            delay: 300,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnimatedCard(
            'Tasbih',
            Icons.bubble_chart_rounded,
            Colors.teal[600]!,
            () => Navigator.pushNamed(context, '/tasbih'),
            delay: 400,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCard(String title, IconData icon, Color color, VoidCallback onTap, {int delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: _buildQuickCard(title, icon, color, onTap),
          ),
        );
      },
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJuzzListCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: _buildCard(
              title: 'Liste des Juzz',
              icon: Icons.list_rounded,
              onTap: () => Navigator.pushNamed(context, '/juzz-list'),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu_book_rounded, color: Colors.green[700], size: 36),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '30 Juzz disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Accéder à tous les chapitres du Coran',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourateListCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: _buildCard(
              title: 'Liste des Sourates',
              icon: Icons.book_rounded,
              onTap: () => Navigator.pushNamed(context, '/sourate-list'),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.library_books_rounded, color: Colors.blue[700], size: 36),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '114 Sourates disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Accéder à toutes les sourates du Coran',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.green[700], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

}

