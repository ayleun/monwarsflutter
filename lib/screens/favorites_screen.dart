import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final items = await FavoritesService.loadFavorites();
    setState(() {
      favorites = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
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
        child: favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun favori pour le moment',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajoutez des versets ou pages à vos favoris',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'images/j${favorite['juzzNumber']}_${favorite['pageNumber']}.webp',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Icon(Icons.bookmark, color: Colors.green[700], size: 28),
                        ),
                      ),
                      title: Text(
                        favorite['title'] ?? 'Favori',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        favorite['subtitle'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          _removeFavorite(index);
                        },
                      ),
                    ),
                  );
                },
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

  void _removeFavorite(int index) {
    final removed = favorites.removeAt(index);
    setState(() {});
    FavoritesService.removeFavorite(removed['juzzNumber'], removed['pageNumber']);
  }
}




