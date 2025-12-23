import 'package:flutter/material.dart';
import '../models/sourate_item.dart';
import '../services/sourate_data_service.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class SourateListScreen extends StatefulWidget {
  const SourateListScreen({super.key});

  @override
  State<SourateListScreen> createState() => _SourateListScreenState();
}

class _SourateListScreenState extends State<SourateListScreen> {
  late List<SourateItem> sourateList;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    sourateList = SourateDataService.getAllSourates();
  }

  List<SourateItem> get _filteredSourates {
    if (_searchQuery.isEmpty) {
      return sourateList;
    }
    return sourateList.where((sourate) {
      return sourate.nameFrench.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sourate.nameArabic.contains(_searchQuery) ||
          sourate.nameTransliteration.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sourate.sourateNumber.toString().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Sourates'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green[50]!,
                    Colors.white,
                  ],
                ),
          color: isDark ? const Color(0xFF121212) : null,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher une sourate...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.green[700]!,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Liste des sourates
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: NavigationHelper.shouldShowNavbar(context) 
                        ? MediaQuery.of(context).padding.bottom + 100.0 
                        : MediaQuery.of(context).padding.bottom + 20.0,
                  ),
                  itemCount: _filteredSourates.length,
                  itemBuilder: (context, index) {
                    final sourate = _filteredSourates[index];
                    return _buildSourateCard(sourate, isDark);
                  },
                ),
              ),
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

  Widget _buildSourateCard(SourateItem sourate, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Trouver le juzz et la page dans le juzz à partir de la page de début de la sourate
          final juzzAndPage = SourateDataService.findJuzzAndPageFromGlobalPage(sourate.startPage);
          if (juzzAndPage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Impossible de trouver le juzz pour ${sourate.nameFrench}')),
            );
            return;
          }
          
          final juzzNumber = juzzAndPage['juzzNumber']!;
          final pageInJuzz = juzzAndPage['pageInJuzz']!;
          final sourateDescription = '${sourate.nameFrench} (${sourate.sourateNumber})';
          
          // Naviguer vers l'écran de lecture avec le juzz et la page appropriés
          Navigator.pushNamed(
            context,
            '/reading',
            arguments: {
              'juzzNumber': juzzNumber,
              'lastPosition': pageInJuzz, // Commencer à la page de début de la sourate
              'sourateDescription': sourateDescription,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _numberIcon(sourate.sourateNumber),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sourate.nameFrench,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: sourate.revelationType == 'Meccan'
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sourate.revelationType == 'Meccan' ? 'Mecquoise' : 'Médinoise',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: sourate.revelationType == 'Meccan'
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sourate.nameArabic,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.green[400] : Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sourate.numberOfAyahs} versets',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.grey[400] : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberIcon(int number) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

