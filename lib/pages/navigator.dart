import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hu/pages/drawer_pages/about_us.dart';
import 'package:hu/pages/drawer_pages/campuses.dart';
import 'package:hu/pages/drawer_pages/developer_profile.dart';
import 'package:hu/pages/drawer_pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hu/pages/exit_exam/my_exam_history_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
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
                      fontSize: 20,
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
            // GENERAL Section
            _sectionHeading(theme, 'GENERAL'),
            _drawerTile(
              context,
              icon: Icons.info_outline,
              label: 'About',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
                onMenuItemClicked(0);
              },
            ),
            _drawerTile(
              context,
              icon: FontAwesomeIcons.buildingColumns,
              label: 'Campuses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CampusesPage()),
                );
                onMenuItemClicked(1);
              },
            ),
            _divider(),
            // ACCOUNT Section
            _sectionHeading(theme, 'ACCOUNT'),
            _drawerTile(
              context,
              icon: Icons.person,
              label: 'Developer',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeveloperProfile()),
                );
              },
            ),
            _drawerTile(
              context,
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Spacer(),
            // Logout Button at Bottom
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout == true) {
                    // Clear Firebase Auth
                    await FirebaseAuth.instance.signOut();
                    // Clear secure storage for credentials and biometric
                    const FlutterSecureStorage secureStorage =
                        FlutterSecureStorage();
                    await secureStorage.delete(key: 'stored_password');
                    await secureStorage.delete(key: 'biometric_enabled');
                    await secureStorage.delete(key: 'last_logged_in_email');
                    // Clear remember me from SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('remember_me');
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary, size: 26),
      title: Text(
        label,
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      hoverColor: theme.colorScheme.primary.withOpacity(0.07),
      splashColor: theme.colorScheme.primary.withOpacity(0.10),
    );
  }

  Widget _sectionHeading(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 28, thickness: 1);
}
