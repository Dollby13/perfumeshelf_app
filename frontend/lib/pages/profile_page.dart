import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_api.dart';
import '../theme/app_colors.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final AppUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authApi = AuthApi();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final updatedUser = widget.user.copyWith(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      bio: bioController.text.trim(),
    );

    if (updatedUser.name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama wajib diisi')));
      return;
    }

    setState(() => isSaving = true);

    try {
      final savedUser = await authApi.updateProfile(updatedUser);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context, savedUser);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan profil ke server')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primaryDark,
                  child: Icon(Icons.person, color: Colors.white, size: 58),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Nama'),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Email'),
              const SizedBox(height: 8),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: widget.user.email,
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Nomor Telepon'),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                ),
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
                  onPressed: isSaving ? null : saveProfile,
                  child: Text(isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
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
                      borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
