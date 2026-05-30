import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 90, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'PerfumeShelf',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Koleksi Parfum Pribadi',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
