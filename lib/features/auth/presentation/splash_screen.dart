import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Subtle background elements
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryEmerald.withOpacity(0.05),
              ),
            ),
          ).animate().fadeIn(duration: 1.seconds).scale(),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.shoppingBag,
                    size: 80,
                    color: AppTheme.primaryEmerald,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).rotate(begin: 0, end: 0.05),
                const SizedBox(height: 24),
                Text(
                  'Pantri',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(delay: 300.ms).moveY(begin: 10, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Smart household management',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 60),
                const SizedBox(
                  width: 40,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryEmerald),
                  ),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
