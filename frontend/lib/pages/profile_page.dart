import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final imagePicker = ImagePicker();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;
  late String profilePhoto;
  bool isSaving = false;

  bool get canEditPhoto => widget.user.role == UserRole.user;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    bioController = TextEditingController(text: widget.user.bio);
    profilePhoto = widget.user.profilePhoto;
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
      profilePhoto: canEditPhoto ? profilePhoto : widget.user.profilePhoto,
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

  Uint8List? profilePhotoBytes() {
    if (profilePhoto.trim().isEmpty) return null;

    final parts = profilePhoto.split(',');
    final encoded = parts.length > 1 ? parts.last : profilePhoto;

    try {
      return base64Decode(encoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> pickProfilePhoto() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      maxHeight: 700,
      imageQuality: 82,
    );

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    if (!mounted) return;

    setState(() {
      profilePhoto = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    });
  }

  void removeProfilePhoto() {
    setState(() => profilePhoto = '');
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
    final photoBytes = profilePhotoBytes();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.secondary,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primary,
                        backgroundImage: photoBytes == null
                            ? null
                            : MemoryImage(photoBytes),
                        child: photoBytes == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 58,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.user.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFE8DFDC)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.34),
                        ),
                      ),
                      child: Text(
                        widget.user.role == UserRole.admin ? 'Admin' : 'User',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (canEditPhoto) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: pickProfilePhoto,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Pilih Foto'),
                      ),
                    ),
                    if (profilePhoto.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        color: AppColors.danger,
                        onPressed: removeProfilePhoto,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ],
                ),
              ],
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
