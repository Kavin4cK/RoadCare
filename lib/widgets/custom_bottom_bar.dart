import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item for the bottom navigation bar
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final int? badgeCount;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.badgeCount,
  });
}

/// Custom Bottom Navigation Bar for civic-tech application
/// Provides core navigation functionality with contextual badge notifications
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
  });

  // Core navigation items for civic engagement
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/splash-screen',
    ),
    NavigationItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Report',
      route: '/report-issue-screen',
    ),
    NavigationItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Map',
      route: '/issue-details-screen',
      badgeCount: 3, // Example: 3 nearby issues
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/fixer-profile-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavigationBarItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => _handleNavigation(context, index, item.route),
                  selectedColor: selectedItemColor ?? colorScheme.primary,
                  unselectedColor:
                      unselectedItemColor ?? colorScheme.onSurfaceVariant,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index, String route) {
    if (onTap != null) {
      onTap!(index);
    }

    // Navigate to the selected route
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}

/// Individual navigation bar item widget
class _NavigationBarItem extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavigationBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: color,
                  size: 24,
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        item.badgeCount! > 99
                            ? '99+'
                            : item.badgeCount.toString(),
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              item.label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
