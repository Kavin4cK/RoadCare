import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item configuration for the custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final int? badgeCount;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.badgeCount,
  });
}

/// Custom Tab Bar for civic-tech application
/// Provides flexible tabbed navigation with badge support
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<TabItem> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final TabBarIndicatorSize indicatorSize;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
    this.indicatorSize = TabBarIndicatorSize.tab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        labelColor: selectedColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorSize: indicatorSize,
        indicatorWeight: 3.0,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabItem tab) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null || tab.customIcon != null) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                tab.customIcon ?? Icon(tab.icon, size: 20),
                if (tab.badgeCount != null && tab.badgeCount! > 0)
                  Positioned(
                    right: -8,
                    top: -8,
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
                        tab.badgeCount! > 99
                            ? '99+'
                            : tab.badgeCount.toString(),
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
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              tab.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Predefined tab configurations for common civic-tech use cases
class CivicTabConfigurations {
  /// Issue status tabs for filtering issues
  static const List<TabItem> issueStatusTabs = [
    TabItem(
      label: 'All Issues',
      icon: Icons.list_alt,
      badgeCount: 24,
    ),
    TabItem(
      label: 'Open',
      icon: Icons.report_problem_outlined,
      badgeCount: 12,
    ),
    TabItem(
      label: 'In Progress',
      icon: Icons.construction_outlined,
      badgeCount: 8,
    ),
    TabItem(
      label: 'Resolved',
      icon: Icons.check_circle_outline,
      badgeCount: 4,
    ),
  ];

  /// Issue category tabs for browsing by type
  static const List<TabItem> issueCategoryTabs = [
    TabItem(
      label: 'Infrastructure',
      icon: Icons.build_outlined,
    ),
    TabItem(
      label: 'Safety',
      icon: Icons.security_outlined,
    ),
    TabItem(
      label: 'Environment',
      icon: Icons.eco_outlined,
    ),
    TabItem(
      label: 'Transportation',
      icon: Icons.directions_bus_outlined,
    ),
  ];

  /// User activity tabs for profile sections
  static const List<TabItem> userActivityTabs = [
    TabItem(
      label: 'Reported',
      icon: Icons.report_outlined,
      badgeCount: 5,
    ),
    TabItem(
      label: 'Fixed',
      icon: Icons.handyman_outlined,
      badgeCount: 12,
    ),
    TabItem(
      label: 'Following',
      icon: Icons.visibility_outlined,
      badgeCount: 3,
    ),
  ];
}
