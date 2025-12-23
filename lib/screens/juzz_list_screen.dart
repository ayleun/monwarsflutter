import 'package:flutter/material.dart';
import '../models/juzz_item.dart';
import '../services/juzz_data_service.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class JuzzListScreen extends StatefulWidget {
  const JuzzListScreen({super.key});

  @override
  State<JuzzListScreen> createState() => _JuzzListScreenState();
}

class _JuzzListScreenState extends State<JuzzListScreen> {
  late List<JuzzItem> juzzList;

  @override
  void initState() {
    super.initState();
    juzzList = JuzzDataService.getAllJuzz();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Juzz'),
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
        child: ListView.builder(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
              bottom: NavigationHelper.shouldShowNavbar(context) 
                  ? MediaQuery.of(context).padding.bottom + 100.0 
                  : MediaQuery.of(context).padding.bottom + 20.0,
            ),
          itemCount: juzzList.length,
          itemBuilder: (context, index) {
            final juzz = juzzList[index];
              return _buildJuzzCard(juzz, isDark);
          },
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

  Widget _buildJuzzCard(JuzzItem juzz, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to reading screen
          Navigator.pushNamed(
            context,
            '/reading',
            arguments: {
              'juzzNumber': juzz.juzzNumber,
              'sourateDescription': juzz.sourateDescription,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _numberIcon(juzz.juzzNumber),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      juzz.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      juzz.sourateDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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




