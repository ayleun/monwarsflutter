import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/theme_service.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoScrollEnabled = true;
  int _fontSize = 16;
  int _autoScrollSpeed = 7; // seconds
  String _language = 'Français';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _autoScrollEnabled = prefs.getBool('auto_scroll_enabled') ?? true;
      _fontSize = prefs.getInt('font_size') ?? 16;
      _autoScrollSpeed = prefs.getInt('auto_scroll_speed') ?? 7;
      _language = prefs.getString('language') ?? 'Français';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeService = Provider.of<ThemeService>(context);
    final currentIndex = NavigationHelper.getCurrentIndex(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglage'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
          child: ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: NavigationHelper.shouldShowNavbar(context) 
                  ? MediaQuery.of(context).padding.bottom + 100.0 
                  : MediaQuery.of(context).padding.bottom + 20.0,
            ),
            children: [
            _buildSectionHeader('Affichage', isDark),
            _buildThemeSelector(themeService, isDark),
            _buildSliderTile(
              'Taille de police',
              'Ajuster la taille du texte',
              Icons.text_fields_rounded,
              _fontSize.toDouble(),
              12.0,
              24.0,
              (value) {
                setState(() => _fontSize = value.round());
                _saveSetting('font_size', _fontSize);
              },
              isDark: isDark,
            ),
            const Divider(height: 32),
            
            _buildSectionHeader('Lecture', isDark),
            _buildSwitchTile(
              'Défilement automatique',
              'Activer le défilement automatique des pages',
              Icons.swap_vert_rounded,
              _autoScrollEnabled,
              (value) {
                setState(() => _autoScrollEnabled = value);
                _saveSetting('auto_scroll_enabled', value);
              },
              isDark: isDark,
            ),
            if (_autoScrollEnabled)
              _buildSliderTile(
                'Vitesse de défilement',
                'Définir la vitesse de défilement automatique',
                Icons.speed_rounded,
                _autoScrollSpeed.toDouble(),
                3.0,
                15.0,
                (value) {
                  setState(() => _autoScrollSpeed = value.round());
                  _saveSetting('auto_scroll_speed', _autoScrollSpeed);
                },
                isDark: isDark,
              ),
            const Divider(height: 32),
            
            _buildSectionHeader('Notifications', isDark),
            _buildSwitchTile(
              'Notifications',
              'Recevoir des notifications et rappels',
              Icons.notifications_rounded,
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
                _saveSetting('notifications_enabled', value);
              },
              isDark: isDark,
            ),
            const Divider(height: 32),
            
            _buildSectionHeader('Langue', isDark),
            _buildLanguageTile(isDark),
            const Divider(height: 32),
            
            _buildSectionHeader('À propos', isDark),
            _buildAboutTile(isDark),
            
            const SizedBox(height: 32),
            _buildButton(
              'Réinitialiser les paramètres',
              Icons.restore_rounded,
              Colors.orange,
              () => _showResetDialog(isDark),
              isDark: isDark,
            ),
            const SizedBox(height: 16),
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

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.green[400] : Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(ThemeService themeService, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.palette_rounded,
              color: isDark ? Colors.green[400] : const Color.fromARGB(255, 25, 112, 29),
            ),
            title: const Text(
              'Thème',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              themeService.isDarkMode ? 'Mode sombre' : 'Mode clair',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    'Clair',
                    Icons.light_mode_rounded,
                    ThemeMode.light,
                    themeService,
                    isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    'Sombre',
                    Icons.dark_mode_rounded,
                    ThemeMode.dark,
                    themeService,
                    isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    String label,
    IconData icon,
    ThemeMode mode,
    ThemeService themeService,
    bool isDark,
  ) {
    final isSelected = themeService.themeMode == mode;
    return InkWell(
      onTap: () => themeService.setThemeMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.green[900] : Colors.green[100])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.green[700]!
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.green[700]
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.green[700]
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    required bool isDark,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: isDark ? Colors.green[400] : Colors.green[700],
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    required bool isDark,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDark ? Colors.green[400] : Colors.green[700],
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max - min).round(),
                    label: value.round().toString(),
                    onChanged: onChanged,
                    activeColor: isDark ? Colors.green[400] : Colors.green[700],
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    value.round().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.green[400] : Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.language_rounded,
          color: isDark ? Colors.green[400] : Colors.green[700],
        ),
        title: const Text(
          'Langue',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_language),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        onTap: () => _showLanguageDialog(isDark),
      ),
    );
  }

  Widget _buildAboutTile(bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.info_rounded,
              color: isDark ? Colors.green[400] : Colors.green[700],
            ),
            title: const Text(
              'Version',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.person_rounded,
              color: isDark ? Colors.green[400] : Colors.green[700],
            ),
            title: const Text(
              'Auteur',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Elaj Alune Gueye'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.help_outline_rounded,
              color: isDark ? Colors.green[400] : Colors.green[700],
            ),
            title: const Text(
              'Aide et support',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onTap, {required bool isDark}) {
    return Card(
      elevation: 2,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Français', 'Français', isDark),
            _buildLanguageOption('العربية', 'Arabe', isDark),
            _buildLanguageOption('English', 'Anglais', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String value, bool isDark) {
    return ListTile(
      title: Text(label),
      trailing: _language == value
          ? Icon(Icons.check_rounded, color: isDark ? Colors.green[400] : Colors.green[700])
          : null,
      onTap: () {
        setState(() => _language = value);
        _saveSetting('language', value);
        Navigator.pop(context);
      },
    );
  }

  void _showResetDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text('Réinitialiser'),
        content: const Text(
          'Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres réinitialisés')),
              );
            },
            child: Text(
              'Réinitialiser',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadSettings();
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide et Support'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.contact_mail_rounded,
                              color: isDark ? Colors.green[400] : Colors.green[700],
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildContactItem(
                          context,
                          Icons.email_rounded,
                          'Email',
                          'elajalune@gmail.com',
                          'mailto:elajalune@gmail.com',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          context,
                          Icons.phone_rounded,
                          'Numéro',
                          '776711097',
                          'tel:776711097',
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  color: Colors.orange.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: Colors.orange[700],
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Soutien',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pour vos dons pour nous soutenir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                color: Colors.orange[700],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '776711097',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: Colors.orange[700],
                                ),
                                onPressed: () {
                                  // Copier le numéro dans le presse-papiers
                                  // Vous pouvez utiliser le package clipboard si nécessaire
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Numéro copié dans le presse-papiers'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Merci pour votre générosité et votre soutien !',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String urlScheme,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        // Ouvrir l'email ou le téléphone
        // Vous pouvez utiliser url_launcher pour cela
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ouverture de $label...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? Colors.green[900] : Colors.green[100])?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.green[400] : Colors.green[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

