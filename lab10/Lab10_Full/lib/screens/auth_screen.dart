import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/api_auth_service.dart';
import '../services/google_auth_service.dart';
import '../services/notification_service.dart';
import '../services/session_manager.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _apiFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspassword');

  final _apiAuth = ApiAuthService();
  final _googleAuth = GoogleAuthService();
  final _sessionManager = SessionManager();
  final _notificationService = NotificationService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillAccount(String u, String p) {
    setState(() {
      _usernameController.text = u;
      _passwordController.text = p;
    });
  }

  Future<void> _completeLogin(AppUser user) async {
    // 1. Persist session
    await _sessionManager.saveSession(user);

    // 2. Trigger Local Notification (Mandatory LO7 requirement upon key user action)
    await _notificationService.showNotification(
      id: 101,
      title: 'Login Successful! 🎉',
      body: 'Welcome back, ${user.fullName} (${user.email}). Session persisted.',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful! Welcome ${user.fullName}'),
        backgroundColor: Colors.green.shade700,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  Future<void> _loginWithApi() async {
    if (!_apiFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = await _apiAuth.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      await _completeLogin(user);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final user = await _googleAuth.signInWithGoogle();
      await _completeLogin(user);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Brand
                Icon(
                  Icons.shield_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Lab 10 Integrated App',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Authentication • Session Management • Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    tabs: const [
                      Tab(icon: Icon(Icons.http, size: 20), text: 'REST API Login'),
                      Tab(icon: Icon(Icons.g_mobiledata, size: 28), text: 'Google Sign-In'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tab Contents
                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Real REST API Login (DummyJSON)
                      Form(
                        key: _apiFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'emilys',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'emilyspassword',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter password' : null,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _loginWithApi,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Sign In via REST API', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 14),
                            // Quick test chips
                            Wrap(
                              spacing: 8,
                              children: [
                                ActionChip(
                                  label: const Text('emilys / emilyspassword', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillAccount('emilys', 'emilyspassword'),
                                ),
                                ActionChip(
                                  label: const Text('michaelw / michaelwpassword', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillAccount('michaelw', 'michaelwpassword'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tab 2: Firebase Google Sign-In
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.account_circle, size: 56, color: Colors.blue.shade700),
                          const SizedBox(height: 12),
                          const Text(
                            'One-Click Google Authentication',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Authenticates via Google Sign-In & Firebase Auth with automatic session saving.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: _isLoading ? null : _loginWithGoogle,
                            icon: const Icon(Icons.login, color: Colors.blue),
                            label: const Text('Continue with Google Account', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.blue.shade300, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
