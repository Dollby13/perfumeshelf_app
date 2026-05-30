import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_api.dart';
import '../theme/app_colors.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'user_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authApi = AuthApi();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      final user = await authApi.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (!mounted) return;

      final destination = user.role == UserRole.admin
          ? const HomePage()
          : const UserHomePage();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    } on AuthApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server Laravel')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.spa, size: 90, color: AppColors.primary),
                  const SizedBox(height: 20),
                  const Text(
                    'PerfumeShelf',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk ke akun kamu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: Text(isLoading ? 'Memproses...' : 'Login'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: openRegister,
                    child: const Text(
                      'Belum punya akun? Register',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
