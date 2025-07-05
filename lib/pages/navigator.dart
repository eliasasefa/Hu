import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mywebapp/pages/drawer_pages/about_us.dart';
import 'package:mywebapp/pages/drawer_pages/campuses.dart';
import 'package:mywebapp/pages/drawer_pages/developer_profile.dart';
import 'package:mywebapp/pages/drawer_pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBar extends StatelessWidget {
  final Function(int) onMenuItemClicked;
  final VoidCallback toggleTheme;

  const NavBar({
    super.key,
    required this.onMenuItemClicked,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.colorScheme.surface, theme.colorScheme.background]
                : [
                    theme.colorScheme.primary.withOpacity(0.08),
                    theme.colorScheme.background
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Modern Drawer Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.85),
                    theme.colorScheme.primary.withOpacity(0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundImage:
                        const AssetImage('assets/images/hu1-logo.png'),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Haramaya University',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                      fontSize: 22,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'haramaya@haramaya.edu.et',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _buildNavItem(
              context,
              icon: Icons.info,
              label: 'About',
              accent: theme.colorScheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
                onMenuItemClicked(0);
              },
            ),
            _buildNavItem(
              context,
              icon: FontAwesomeIcons.buildingColumns,
              label: 'Campuses',
              accent: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CampusesPage()),
                );
                onMenuItemClicked(1);
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.person,
              label: 'Developer',
              accent: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeveloperProfile()),
                );
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.settings,
              label: 'Settings',
              accent: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const SizedBox(height: 18),
            const Divider(),
            _buildNavItem(
              context,
              icon: Icons.logout,
              label: 'Logout',
              accent: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color accent = Colors.blueGrey}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
