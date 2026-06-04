import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_api.dart';
import '../theme/app_colors.dart';
import '../widgets/app_brand_mark.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'user_home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final authApi = AuthApi();

  @override
  void initState() {
    super.initState();

    openInitialPage();
  }

  Future<void> openInitialPage() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = await authApi.readStoredToken();
    Widget destination = const LoginPage();

    if (token != null && token.isNotEmpty) {
      try {
        final user = await authApi.fetchProfile(token);
        destination = user.role == UserRole.admin
            ? HomePage(user: user)
            : UserHomePage(user: user);
      } catch (_) {
        await authApi.clearStoredToken();
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF0F5E5C),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -52,
              child: _SplashGlow(size: 220, color: AppColors.secondary),
            ),
            Positioned(
              bottom: -96,
              left: -64,
              child: _SplashGlow(size: 260, color: AppColors.accent),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBrandMark(size: 108, iconSize: 66, inverted: true),
                  SizedBox(height: 22),
                  Text(
                    'PerfumeShelf',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ruang Komunitas Parfum',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 36),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _SplashGlow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.10),
      ),
    );
  }
}
