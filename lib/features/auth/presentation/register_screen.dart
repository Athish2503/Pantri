import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      await ref.read(authNotifierProvider.notifier).register(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
          );

      final authState = ref.read(authNotifierProvider);
      if (authState.hasError && mounted) {
        final errorMsg = authState.error.toString();
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
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.userPlus,
                    size: 48,
                    color: AppTheme.primaryEmerald,
                  ),
                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 24),
                
                Text(
                  'Join Pantri',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms),
                
                const SizedBox(height: 8),
                
                Text(
                  'Start managing your kitchen inventory with ease.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 40),
                
                // Form Fields
                TextFormField(
                  controller: _nameController,
                  enabled: !isLoading,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Display Name',
                    prefixIcon: Icon(LucideIcons.user, size: 20),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Name required' : null,
                ).animate().fadeIn(delay: 300.ms).moveX(begin: -10, end: 0),
                
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(LucideIcons.mail, size: 20),
                  ),
                  validator: (value) => (value == null || !value.contains('@')) ? 'Valid email required' : null,
                ).animate().fadeIn(delay: 400.ms).moveX(begin: -10, end: 0),
                
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
                  validator: (value) => (value == null || value.length < 6) ? 'Min 6 characters' : null,
                ).animate().fadeIn(delay: 500.ms).moveX(begin: -10, end: 0),
                
                const SizedBox(height: 32),

                // Register Button
                ElevatedButton(
                  onPressed: isLoading ? null : _submitRegistration,
                  child: isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create Account'),
                ).animate().fadeIn(delay: 600.ms).scale(),
                
                const SizedBox(height: 24),

                // Back link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
