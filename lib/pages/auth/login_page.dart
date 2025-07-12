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

  Future<void> _enableBiometric() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        setState(() {
          _error = 'Please enter your email and password first.';
          _loading = false;
        });
        return;
      }
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (isAuthenticated) {
        print('[DEBUG] Enabling biometric for email: '
            '[32m${_emailController.text.trim()}[0m, password: [32m${_passwordController.text.trim()}[0m');
        await _secureStorage.write(
            key: 'last_logged_in_email', value: _emailController.text.trim());
        await _secureStorage.write(
            key: 'stored_password', value: _passwordController.text.trim());
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        setState(() {
          _biometricEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login enabled!')),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to enable biometric authentication.';
      });
    } finally {
      setState(() {
        _loading = false;
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
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('[DEBUG] Writing last_logged_in_email: '
            '[32m${_emailController.text.trim()}[0m');
        await _secureStorage.write(
            key: 'last_logged_in_email', value: _emailController.text.trim());
        if (_biometricEnabled) {
          print('[DEBUG] Writing stored_password: '
              '[32m${_passwordController.text.trim()}[0m');
          await _secureStorage.write(
              key: 'stored_password', value: _passwordController.text.trim());
        }
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('[DEBUG] Writing last_logged_in_email: '
            '[32m${_emailController.text.trim()}[0m');
        print('[DEBUG] Writing stored_password: '
            '[32m${_passwordController.text.trim()}[0m');
        await _secureStorage.write(
            key: 'last_logged_in_email', value: _emailController.text.trim());
        await _secureStorage.write(
            key: 'stored_password', value: _passwordController.text.trim());
      }
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
                    if (_isLogin &&
                        _biometricAvailable &&
                        !_biometricEnabled &&
                        _showBiometricBanner)
                      Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.fingerprint, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tired of typing your password? Enable biometric login for quick access!',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Dismiss',
                              onPressed: () {
                                setState(() {
                                  _showBiometricBanner = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    if (_isLogin &&
                        _biometricAvailable &&
                        !_biometricEnabled &&
                        _showBiometricBanner)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Enable Now'),
                          onPressed: _loading ? null : _enableBiometric,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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
                    // Show prompt/banner/button to enable biometric after manual login
                    if (_showEnableBiometricPrompt &&
                        _biometricAvailable &&
                        !_biometricEnabled)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.fingerprint),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'You can enable biometric login for faster sign in next time.',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _loading ? null : _enableBiometric,
                                  child: const Text('Enable'),
                                ),
                              ],
                            ),
                          ),
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
                    // Show enable biometric button if available but not enabled
                    if (_biometricAvailable && !_biometricEnabled) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Enable Biometric Login'),
                          onPressed: _loading ? null : _enableBiometric,
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
