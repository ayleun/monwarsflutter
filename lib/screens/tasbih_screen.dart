import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_bottom_navbar.dart';
import '../utils/navigation_helper.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with TickerProviderStateMixin {
  int _count = 0;
  int _goal = 33;
  late final AnimationController _pulseController;
  late final AnimationController _nudgeController;
  int _activeBeadIndex = 0;

  static const int _beadCount = 32;

  void _increment() {
    setState(() {
      _count++;
      _activeBeadIndex = (_activeBeadIndex + 1) % _beadCount;
    });
    HapticFeedback.vibrate();
    _pulseController.forward(from: 0.0);
    _nudgeController.forward(from: 0.0);
    
    // Réinitialiser quand on atteint le but
    if (_count >= _goal) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _reset();
          HapticFeedback.heavyImpact();
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _count = 0;
      _activeBeadIndex = 0;
    });
    HapticFeedback.heavyImpact();
  }

  void _setGoal(int g) {
    setState(() {
      _goal = g;
      _count = 0;
      _activeBeadIndex = 0;
    });
    HapticFeedback.selectionClick();
  }

  void _setCustomGoal(bool isDark) {
    final currentValue = (_goal != 33 && _goal != 99 && _goal != 100 && _goal != 1000) 
        ? _goal.toString() 
        : '';
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final TextEditingController controller = TextEditingController(text: currentValue);
        
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            'Objectif personnalisé',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              labelText: 'Nombre de comptes',
              hintText: 'Entre 1 et 10000',
              labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green[700]!, width: 2),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0 && value <= 10000) {
                  _setGoal(value);
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Veuillez entrer un nombre entre 1 et 10000'),
                      backgroundColor: Colors.red[700],
                    ),
                  );
                }
              },
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..addListener(() => setState(() {}));
    _nudgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nudgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = NavigationHelper.getCurrentIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
                : [Colors.green[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildInfoCard(isDark),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(child: _buildCounterCircle(isDark)),
                ),
                const SizedBox(height: 12),
                _buildGoalSelector(isDark),
                const SizedBox(height: 24),
                _buildBottomControls(isDark),
              ],
            ),
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

  Widget _buildInfoCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Dhikr en cours',
            style: TextStyle(
              color: isDark ? Colors.green[300] : Colors.green[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_count',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'sur $_goal',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSelector(bool isDark) {
    final isCustomGoal = _goal != 33 && _goal != 99 && _goal != 100 && _goal != 1000;
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        _chip(33, isDark),
        _chip(99, isDark),
        _chip(100, isDark),
        _chip(1000, isDark),
        _customChip(isDark, isCustomGoal),
      ],
    );
  }

  Widget _customChip(bool isDark, bool isSelected) {
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[300] : Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            Text(
              isSelected ? '$_goal' : 'Personnalisé',
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[300] : Colors.grey[700]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        fontWeight: FontWeight.w600,
      ),
      selected: isSelected,
      onSelected: (_) => _setCustomGoal(isDark),
      backgroundColor: isDark
          ? Colors.grey[800]!.withOpacity(0.5)
          : Colors.grey[200]!.withOpacity(0.5),
      selectedColor: Colors.green[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }

  Widget _buildBottomControls(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _roundButton(Icons.volume_up_rounded, () {}, isDark),
        _roundButton(Icons.restart_alt_rounded, _reset, isDark, bg: Colors.orange[600]),
        _roundButton(Icons.add_rounded, _increment, isDark, bg: Colors.green[700]),
      ],
    );
  }

  Widget _buildCounterCircle(bool isDark) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_pulseController, _nudgeController]),
            builder: (context, child) {
              return _buildBeadsRing();
            },
          ),
          AnimatedScale(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            scale: 1 + 0.06 * Curves.easeOut.transform(_pulseController.value),
            child: GestureDetector(
              onTap: _increment,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.green[600]!, Colors.green[800]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.35),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('comptes', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeadsRing() {
    return CustomPaint(
      size: const Size(240, 240),
      painter: _TasbihBeadsPainter(
        beadCount: _beadCount,
        activeIndex: _activeBeadIndex,
        pulse: Curves.easeOut.transform(_pulseController.value),
        nudge: Curves.easeOut.transform(_nudgeController.value) * 0.08,
      ),
    );
  }

  Widget _chip(int value, bool isDark) {
    final selected = _goal == value;
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(value.toString()),
      ),
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        fontWeight: FontWeight.w600,
      ),
      selected: selected,
      onSelected: (_) => _setGoal(value),
      backgroundColor: isDark
          ? Colors.grey[800]!.withOpacity(0.5)
          : Colors.grey[200]!.withOpacity(0.5),
      selectedColor: Colors.green[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }


  Widget _roundButton(IconData icon, VoidCallback onTap, bool isDark, {Color? bg}) {
    final defaultColor = isDark ? Colors.green[600] : Colors.green[700];
    final buttonColor = bg ?? defaultColor!;
    return InkResponse(
      onTap: onTap,
      radius: 36,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              buttonColor,
              buttonColor.darken(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}

class _TasbihBeadsPainter extends CustomPainter {
  _TasbihBeadsPainter({
    required this.beadCount,
    required this.activeIndex,
    required this.pulse,
    required this.nudge,
  });

  final int beadCount;
  final int activeIndex;
  final double pulse;
  final double nudge;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radiusX = size.width * 0.48;
    final radiusY = size.height * 0.34;

    for (int i = 0; i < beadCount; i++) {
      final double shift = pulse * 0.35 + nudge;
      // Position fixe des perles basée sur leur index, pas de rotation continue
      final theta = (i / beadCount) * 2 * math.pi + shift;

      final bool isActive = i == activeIndex;
      final bool isNext = i == ((activeIndex + 1) % beadCount);
      final double activeOffset = isActive ? 12 * pulse : (isNext ? -6 * pulse : 0);

      final dx = center.dx + (radiusX + activeOffset) * math.cos(theta);
      final dy = center.dy + (radiusY + activeOffset * 0.7) * math.sin(theta);

      final depth = (math.sin(theta) + 1) / 2; // 0 (back) -> 1 (front)
      final beadRadius = ui.lerpDouble(10, 18, depth)! * (isActive ? (1 + 0.22 * pulse) : 1);

      // Utiliser des couleurs vertes pour correspondre au thème
      final lightColor = Color.lerp(
        const Color(0xFF81C784), // Vert clair
        const Color(0xFF66BB6A), // Vert moyen
        depth,
      )!;
      final darkColor = Color.lerp(
        const Color(0xFF388E3C), // Vert foncé
        const Color(0xFF2E7D32), // Vert très foncé
        depth,
      )!.withOpacity(0.9);

      final paint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(dx - beadRadius * 0.3, dy - beadRadius * 0.3),
          beadRadius,
          [lightColor, darkColor],
          [0.0, 1.0],
        );

      canvas.drawCircle(Offset(dx, dy), beadRadius, paint);

      // Cast shadow to enhance 3D feel when bead in front
      if (depth > 0.6) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity((depth - 0.6) * 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(dx + 4, dy + 6), beadRadius * 0.6, shadowPaint);
      }
    }

    // Draw subtle cord - position fixe, pas de rotation continue
    final cordPath = Path();
    const samples = 100;
    for (int i = 0; i <= samples; i++) {
      final theta = (i / samples) * 2 * math.pi;
      final dx = center.dx + radiusX * math.cos(theta);
      final dy = center.dy + radiusY * math.sin(theta);
      if (i == 0) {
        cordPath.moveTo(dx, dy);
      } else {
        cordPath.lineTo(dx, dy);
      }
    }
    final cordPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx - radiusX, center.dy),
        Offset(center.dx + radiusX, center.dy),
        [
          const Color(0xFF2E7D32).withOpacity(0.5), // Vert foncé
          const Color(0xFF1B5E20).withOpacity(0.8), // Vert très foncé
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(cordPath, cordPaint);
  }

  @override
  bool shouldRepaint(covariant _TasbihBeadsPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex ||
        oldDelegate.pulse != pulse ||
        oldDelegate.nudge != nudge;
  }
}

extension _ColorShade on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}


