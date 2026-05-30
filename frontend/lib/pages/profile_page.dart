import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController(text: 'User PerfumeShelf');
  final phoneController = TextEditingController(text: '081234567890');
  final bioController = TextEditingController(
    text: 'Pecinta parfum dengan aroma fresh, woody, dan clean.',
  );

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveProfile() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 58),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Nama'),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 16),
            const Text('Email'),
            const SizedBox(height: 8),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'user@email.com',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Nomor Telepon'),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 16),
            const Text('Bio'),
            const SizedBox(height: 8),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.info)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Simpan Perubahan'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
