import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLogin = true;
  bool _loading = false;
  bool _biometricLoading = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String? _error;
  String? _lastLoggedInEmail;
  bool _showBiometricBanner = true;
  bool _showEnableBiometricPrompt = false;

  @override
  void initState() {
    super.initState();
    _initializeBiometricState();
  }

  Future<void> _initializeBiometricState() async {
    await _checkBiometricSupport();
    await _loadBiometricSettings();
    if (_biometricAvailable && _biometricEnabled) {
      await _attemptBiometricLogin();
    }
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      setState(() {
        _biometricAvailable = isAvailable && isDeviceSupported;
      });
    } catch (e) {
      setState(() {
        _biometricAvailable = false;
      });
    }
  }

  Future<void> _loadBiometricSettings() async {
    try {
      final email = await _secureStorage.read(key: 'last_logged_in_email');
      final password = await _secureStorage.read(key: 'stored_password');
      final biometricEnabled =
          await _secureStorage.read(key: 'biometric_enabled');
      print('[DEBUG] Loaded last_logged_in_email: '
          '[32m$email[0m, biometric_enabled: $biometricEnabled, password: [32m$password[0m');
      bool biometricEnabledFinal =
          biometricEnabled == 'true' && email != null && password != null;
      if (biometricEnabled == 'true' && !biometricEnabledFinal) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'false');
      }
      setState(() {
        _lastLoggedInEmail = email;
        _biometricEnabled = biometricEnabledFinal;
      });
    } catch (e) {
      setState(() {
        _lastLoggedInEmail = null;
        _biometricEnabled = false;
      });
    }
  }

  Future<void> _attemptBiometricLogin() async {
    setState(() {
      _biometricLoading = true;
      _error = null;
    });
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to sign in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (isAuthenticated) {
        final email = await _secureStorage.read(key: 'last_logged_in_email');
        final password = await _secureStorage.read(key: 'stored_password');
        print('[DEBUG] Attempt biometric login with email: '
            '[32m$email[0m, password: [32m$password[0m');
        if (email != null && password != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          widget.onLoginSuccess();
          return;
        } else {
          setState(() {
            _error = 'Stored credentials not found. Please sign in manually.';
            _showEnableBiometricPrompt = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Biometric authentication failed.';
      });
    } finally {
      setState(() {
        _biometricLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Save credentials BEFORE Firebase Auth call for reliability
      await _secureStorage.write(
          key: 'last_logged_in_email', value: _emailController.text.trim());
      await _secureStorage.write(
          key: 'stored_password', value: _passwordController.text.trim());
      final debugEmail = await _secureStorage.read(key: 'last_logged_in_email');
      final debugPassword = await _secureStorage.read(key: 'stored_password');

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (_biometricAvailable && !_biometricEnabled) {
        setState(() {
          _showEnableBiometricPrompt = true;
        });
      }
      widget.onLoginSuccess();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.lock_outline,
                          size: 48, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _isLogin ? 'Sign In' : 'Create Account',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => v == null || !v.contains('@')
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (v) => v == null || v.length < 6
                                ? 'Password too short'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            Text(_error!,
                                style: const TextStyle(color: Colors.red)),
                            if (_showEnableBiometricPrompt)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.login),
                                  label: const Text('Return to Manual Login'),
                                  onPressed: _loading
                                      ? null
                                      : () {
                                          setState(() {
                                            _showEnableBiometricPrompt = false;
                                            _error = null;
                                          });
                                        },
                                ),
                              ),
                          ],
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isLogin ? 'Sign In' : 'Register'),
                      ),
                    ),
                    // Show fingerprint button whenever biometric is enabled and available
                    if (_biometricAvailable && _biometricEnabled) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: IconButton(
                          icon: _biometricLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.fingerprint, size: 48),
                          tooltip: 'Use biometric login',
                          onPressed:
                              _biometricLoading ? null : _attemptBiometricLogin,
                        ),
                      ),
                    ],

                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin
                          ? 'Create an account'
                          : 'Already have an account? Sign In'),
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
}
