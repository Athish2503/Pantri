import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/auth_provider.dart';

final guestModeProvider = StateProvider<bool>((ref) => false);

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      await ref.read(authNotifierProvider.notifier).signIn(
            _emailController.text,
            _passwordController.text,
          );
      _handleAuthResult();
    }
  }

  Future<void> _handleGoogleSignIn() async {
    FocusScope.of(context).unfocus();
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    _handleAuthResult();
  }

  void _handleAuthResult() {
    final authState = ref.read(authNotifierProvider);
    if (authState.hasError && mounted) {
      final errorMsg = authState.error.toString();
      if (!errorMsg.contains('cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg.replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryEmerald.withOpacity(0.05),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).scale(),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Header Section
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryEmerald.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.shoppingBag,
                            size: 48,
                            color: AppTheme.primaryEmerald,
                          ),
                        ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 24),
                        Text(
                          'Pantri',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ).animate().fadeIn(delay: 300.ms).moveY(begin: 10, end: 0),
                        const SizedBox(height: 8),
                        Text(
                          'Smart kitchen management',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                    
                    const SizedBox(height: 48),

                    // Login Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              prefixIcon: Icon(LucideIcons.mail, size: 20),
                            ),
                            validator: (value) => (value == null || !value.contains('@')) ? 'Valid email required' : null,
                          ).animate().fadeIn(delay: 500.ms).moveX(begin: -10, end: 0),
                          
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _passwordController,
                            enabled: !isLoading,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(LucideIcons.lock, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff, size: 20),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) => (value == null || value.isEmpty) ? 'Password required' : null,
                          ).animate().fadeIn(delay: 600.ms).moveX(begin: -10, end: 0),
                          
                          const SizedBox(height: 12),
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ).animate().fadeIn(delay: 700.ms),
                          
                          const SizedBox(height: 24),

                          // Sign In Button
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitLogin,
                            child: isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Sign In'),
                          ).animate().fadeIn(delay: 800.ms).scale(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Social Login
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ).animate().fadeIn(delay: 900.ms),

                    const SizedBox(height: 32),

                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                      ),
                      onPressed: isLoading ? null : _handleGoogleSignIn,
                      icon: const Icon(LucideIcons.chrome, size: 20),
                      label: const Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600)),
                    ).animate().fadeIn(delay: 1000.ms),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                      ),
                      onPressed: isLoading ? null : () {
                        ref.read(guestModeProvider.notifier).state = true;
                        context.go('/pantry');
                      },
                      icon: const Icon(LucideIcons.compass, size: 20),
                      label: const Text('Preview Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
                    ).animate().fadeIn(delay: 1100.ms),

                    const SizedBox(height: 32),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New to Pantri? ', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1200.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
