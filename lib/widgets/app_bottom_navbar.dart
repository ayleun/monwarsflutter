import 'dart:ui';
import 'package:flutter/material.dart';

class AppBottomNavBar extends StatefulWidget {
  final int currentIndex; // -1 means no selection
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.currentIndex >= 0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    // Responsive calculations
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth >= 600;
    
    final horizontalMargin = isSmallScreen ? 8.0 : (isLargeScreen ? 24.0 : 16.0);
    final bottomMargin = isSmallScreen ? 8.0 : 16.0;
    final horizontalPadding = isSmallScreen ? 4.0 : (isLargeScreen ? 12.0 : 8.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isLargeScreen ? 8.0 : 6.0);

    return Container(
      margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isSmallScreen ? 20 : 30),
          topRight: Radius.circular(isSmallScreen ? 20 : 30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isSmallScreen ? 20 : 30),
          topRight: Radius.circular(isSmallScreen ? 20 : 30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF1E1E1E) : Colors.white)
                  .withOpacity(0.7),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.home_rounded,
                      label: 'Accueil',
                      index: 0,
                      isSelected: widget.currentIndex == 0,
                      isDark: isDark,
                      screenWidth: screenWidth,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.menu_book_rounded,
                      label: 'Juzz',
                      index: 1,
                      isSelected: widget.currentIndex == 1,
                      isDark: isDark,
                      screenWidth: screenWidth,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.favorite_rounded,
                      label: 'Favoris',
                      index: 2,
                      isSelected: widget.currentIndex == 2,
                      isDark: isDark,
                      screenWidth: screenWidth,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      label: 'Réglage',
                      index: 3,
                      isSelected: widget.currentIndex == 3,
                      isDark: isDark,
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required bool isDark,
    required double screenWidth,
  }) {
    // Responsive calculations
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth >= 600;
    
    final baseIconSize = isSmallScreen ? 18.0 : (isLargeScreen ? 24.0 : 20.0);
    final baseFontSize = isSmallScreen ? 8.5 : (isLargeScreen ? 11.0 : 9.5);
    final baseHorizontalPadding = isSmallScreen ? 8.0 : (isLargeScreen ? 20.0 : 16.0);
    final baseVerticalPadding = isSmallScreen ? 6.0 : (isLargeScreen ? 10.0 : 8.0);
    final itemMargin = isSmallScreen ? 1.0 : (isLargeScreen ? 4.0 : 2.0);
    
    // Show label only if screen is not too small
    final showLabel = !isSmallScreen || screenWidth >= 320;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(
            begin: isSelected ? 1.0 : 0.0,
            end: isSelected ? 1.0 : 0.0,
          ),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: itemMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: baseHorizontalPadding + (value * (isSmallScreen ? 2 : 4)),
                      vertical: baseVerticalPadding + (value * (isSmallScreen ? 1 : 2)),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
                      color: isSelected
                          ? Colors.orange[600]!.withOpacity(0.15 + (value * 0.1))
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            icon,
                            size: baseIconSize + (value * (isSmallScreen ? 1.5 : 2)),
                            color: isSelected
                                ? Colors.orange[600]
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                        ),
                        if (showLabel) ...[
                          SizedBox(height: isSmallScreen ? 1 : 2),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              fontSize: baseFontSize + (value * (isSmallScreen ? 0.3 : 0.5)),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.orange[600]
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
