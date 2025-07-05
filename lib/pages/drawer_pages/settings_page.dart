import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  bool _loading = true;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      // Check if biometric is available
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      // Load current settings
      final biometricEnabled =
          await _secureStorage.read(key: 'biometric_enabled');
      final userEmail = await _secureStorage.read(key: 'last_logged_in_email');

      setState(() {
        _biometricAvailable = isAvailable && isDeviceSupported;
        _biometricEnabled = biometricEnabled == 'true';
        _userEmail = userEmail;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Enable biometric
      await _enableBiometric();
    } else {
      // Disable biometric
      await _disableBiometric();
    }
  }

  Future<void> _enableBiometric() async {
    try {
      // First, verify the user's current password
      final password = await _showPasswordDialog();
      if (password == null) return;

      // Verify password with Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Reauthenticate to verify password
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
          return;
        }
      }

      // Authenticate with biometrics
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        // Store credentials securely
        await _secureStorage.write(key: 'stored_password', value: password);
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        setState(() {
          _biometricEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Biometric login enabled successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to enable biometric: $e')),
      );
    }
  }

  Future<void> _disableBiometric() async {
    try {
      // Remove stored credentials
      await _secureStorage.delete(key: 'stored_password');
      await _secureStorage.write(key: 'biometric_enabled', value: 'false');
      setState(() {
        _biometricEnabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric login disabled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to disable biometric: $e')),
      );
    }
  }

  Future<String?> _showPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your current password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(passwordController.text),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text(user?.email ?? 'Not available'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('User ID'),
                          subtitle: Text(user?.uid ?? 'Not available'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Security Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_biometricAvailable) ...[
                          SwitchListTile(
                            title: const Text('Biometric Login'),
                            subtitle: const Text(
                                'Use fingerprint or face recognition to sign in'),
                            secondary: const Icon(Icons.fingerprint),
                            value: _biometricEnabled,
                            onChanged: _toggleBiometric,
                          ),
                          if (_biometricEnabled && _userEmail != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8),
                              child: Text(
                                'Linked to: $_userEmail',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ] else ...[
                          ListTile(
                            leading: const Icon(Icons.fingerprint,
                                color: Colors.grey),
                            title: const Text('Biometric Login'),
                            subtitle:
                                const Text('Not available on this device'),
                            enabled: false,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Sign Out'),
                          subtitle: const Text('Sign out of your account'),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
