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
  String _biometricStatus = 'Checking...';
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      // Comprehensive biometric availability check
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      // Load current settings
      final biometricEnabled =
          await _secureStorage.read(key: 'biometric_enabled');
      final userEmail = await _secureStorage.read(key: 'last_logged_in_email');
      final storedPassword = await _secureStorage.read(key: 'stored_password');

      // Determine biometric availability
      bool isAvailable = false;
      String status = 'Not available';

      if (isDeviceSupported && canCheckBiometrics) {
        if (availableBiometrics.isNotEmpty) {
          isAvailable = true;
          status = 'Available';
        } else {
          status = 'No biometrics enrolled';
        }
      } else if (!isDeviceSupported) {
        status = 'Device not supported';
      } else if (!canCheckBiometrics) {
        status = 'Biometric check not available';
      }

      // Only enable biometric if credentials are present
      bool biometricEnabledFinal = biometricEnabled == 'true' &&
          userEmail != null &&
          storedPassword != null;
      if (biometricEnabled == 'true' && !biometricEnabledFinal) {
        // If biometric was enabled but credentials are missing, turn it off
        await _secureStorage.write(key: 'biometric_enabled', value: 'false');
      }

      setState(() {
        _biometricAvailable = isAvailable;
        _biometricEnabled = biometricEnabledFinal;
        _userEmail = userEmail;
        _biometricStatus = status;
        _availableBiometrics = availableBiometrics;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _biometricStatus = 'Error: $e';
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
      // Authenticate with biometrics only
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        // Use only stored credentials
        final email = await _secureStorage.read(key: 'last_logged_in_email');
        final password = await _secureStorage.read(key: 'stored_password');
        print('[DEBUG] Attempting to enable biometric with email: '
            '\u001b[32m$email\u001b[0m, password: \u001b[32m$password\u001b[0m');
        if (email == null || password == null) {
          print(
              '[DEBUG] Stored credentials not found. Email: $email, Password: $password');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Stored credentials not found. Please log in again.')),
          );
          return;
        }
        // No Firebase re-authentication, just enable biometric
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
    String? password;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            autofocus: true,
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
      default:
        return 'Unknown';
    }
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
              padding: const EdgeInsets.all(18),
              children: [
                // Account Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                  child: Text('Account',
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(user?.email ?? 'Not available'),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Security Section
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4),
                  child: Text('Security',
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      leading: Icon(
                        Icons.fingerprint,
                        color: _biometricAvailable
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
                      title: const Text('Biometric Login'),
                      subtitle: Text(_biometricAvailable
                          ? 'Enable quick login with biometrics.'
                          : _biometricStatus == 'No biometrics enrolled'
                              ? 'No biometrics enrolled on this device.'
                              : 'Biometric not available.'),
                      trailing: _biometricAvailable
                          ? Switch(
                              value: _biometricEnabled,
                              onChanged:
                                  (FirebaseAuth.instance.currentUser != null)
                                      ? _toggleBiometric
                                      : null,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (user?.email == 'eliasasefa3@gmail.com')
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.upload_file),
                      title: const Text('Import Exam Questions'),
                      subtitle: const Text(
                          'Import exit exam questions from a JSON file'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/import-exit-exam-questions');
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
