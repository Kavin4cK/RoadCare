import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for civic-tech application
/// Provides consistent navigation and branding across the app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      elevation: elevation,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      actions: actions ?? _buildDefaultActions(context),
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onPrimary,
        size: 24,
      ),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          // Navigate to notifications or show notification panel
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications feature coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        tooltip: 'Notifications',
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) => _handleMenuSelection(context, value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'profile',
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Profile'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'help',
            child: ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    ];
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        Navigator.pushNamed(context, '/fixer-profile-screen');
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings feature coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Help & Support feature coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
