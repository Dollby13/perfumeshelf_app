import 'dart:async';

import 'package:flutter/material.dart';

import '../data/sample_perfumes.dart';
import '../data/shared_reviews.dart';
import '../models/app_user.dart';
import '../models/perfume.dart';
import '../services/auth_api.dart';
import '../services/perfume_api.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import '../widgets/rating_stars.dart';
import '../widgets/app_hero_section.dart';
import 'perfume_detail_page.dart';
import 'perfume_form_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final AppUser user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authApi = AuthApi();
  final perfumeApi = PerfumeApi();
  List<Perfume> perfumes = samplePerfumes();
  late AppUser currentUser;
  bool isLoading = true;
  int selectedIndex = 0;
  int heroImageIndex = 0;
  Timer? heroImageTimer;

  List<String> get heroImageUrls {
    final urls = perfumes
        .map((perfume) => perfume.imageUrl.trim())
        .where((imageUrl) => imageUrl.isNotEmpty)
        .toList();

    if (urls.isEmpty) {
      return [
        'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=1200&q=82',
      ];
    }

    return urls;
  }

  String get heroImageUrl {
    final urls = heroImageUrls;
    return urls[heroImageIndex % urls.length];
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    startHeroImageTimer();
    loadPerfumes();
  }

  void startHeroImageTimer() {
    heroImageTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || heroImageUrls.length <= 1) return;

      setState(() {
        heroImageIndex = (heroImageIndex + 1) % heroImageUrls.length;
      });
    });
  }

  @override
  void dispose() {
    heroImageTimer?.cancel();
    super.dispose();
  }

  Future<void> loadPerfumes() async {
    try {
      final data = await perfumeApi.fetchPerfumes();
      if (!mounted) return;
      setState(() {
        perfumes = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> addPerfume() async {
    final result = await Navigator.push<Perfume>(
      context,
      MaterialPageRoute(builder: (_) => const PerfumeFormPage()),
    );

    if (result == null || !mounted) return;

    try {
      final savedPerfume = await perfumeApi.createPerfume(result);
      if (!mounted) return;

      setState(() {
        perfumes.insert(0, savedPerfume);
        heroImageIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data parfum berhasil ditambahkan')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan parfum ke server')),
      );
    }
  }

  Future<void> openDetail(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => PerfumeDetailPage(perfume: perfumes[index]),
      ),
    );

    if (result == null || !mounted) return;

    if (result['action'] == 'delete') {
      try {
        await perfumeApi.deletePerfume(perfumes[index]);
        if (!mounted) return;

        setState(() {
          perfumes.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data parfum berhasil dihapus')),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus parfum dari server')),
        );
      }
    }

    if (result['action'] == 'update') {
      try {
        final savedPerfume = await perfumeApi.updatePerfume(result['perfume']);
        if (!mounted) return;

        setState(() {
          perfumes[index] = savedPerfume;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data parfum berhasil diperbarui')),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan perubahan ke server')),
        );
      }
    }
  }

  Future<void> openProfile() async {
    final updatedUser = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(builder: (_) => ProfilePage(user: currentUser)),
    );

    if (updatedUser == null || !mounted) return;

    setState(() => currentUser = updatedUser);
  }

  void deleteReview(ReviewEntry entry) {
    setState(() {
      SharedReviews.removeReview(entry.perfumeName, entry.review);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Komentar user berhasil dihapus')),
    );
  }

  Future<void> deleteUserReviews(ReviewEntry entry) async {
    final review = entry.review;

    if (review.reviewerEmail.trim().isEmpty) {
      setState(() {
        SharedReviews.removeReviewsByUser(review.reviewerName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review dari ${review.reviewerName} berhasil dihapus'),
        ),
      );
      return;
    }

    try {
      await authApi.banUser(
        name: review.reviewerName,
        email: review.reviewerEmail,
      );
      if (!mounted) return;

      setState(() {
        SharedReviews.removeReviewsByUser(review.reviewerName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User ${review.reviewerName} berhasil diban oleh admin',
          ),
        ),
      );
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() {
        SharedReviews.removeReviewsByUser(review.reviewerName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${error.message}. Review tetap dihapus.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus user dari server')),
      );
    }
  }

  List<ReviewEntry> reviewUserEntries() {
    final seenUsers = <String>{};
    final users = <ReviewEntry>[];

    for (final entry in SharedReviews.allReviews()) {
      final review = entry.review;
      final key = review.reviewerEmail.trim().isNotEmpty
          ? review.reviewerEmail.trim().toLowerCase()
          : review.reviewerName.trim().toLowerCase();

      if (seenUsers.add(key)) {
        users.add(entry);
      }
    }

    return users;
  }

  Widget buildHomeContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (perfumes.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada koleksi parfum',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            AppHeroSection(
              eyebrow: 'Admin dashboard',
              title: 'Kelola katalog parfum publik',
              description:
                  'Pastikan koleksi, status, dan review tetap rapi agar pengguna mudah menemukan parfum yang tepat.',
              icon: Icons.inventory_2,
              metricLabel: 'Parfum aktif',
              metricValue: '${perfumes.length}',
              imageUrl: heroImageUrl,
            ),
            const SizedBox(height: 18),
            const Text(
              'Katalog Parfum Publik',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sebagai admin, kelola daftar parfum yang tampil untuk publik.',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),
            ...List.generate(perfumes.length, (index) {
              final perfume = perfumes[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => openDetail(index),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        PerfumePhoto(imageUrl: perfume.imageUrl),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                perfume.namaParfum,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${perfume.merek} - ${perfume.aroma}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _StatusPill(label: perfume.status),
                                  _InfoPill(
                                    icon: Icons.local_offer_outlined,
                                    label: perfume.konsentrasi,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildReviewContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            AppHeroSection(
              eyebrow: 'Kelola coment',
              title: 'Pantau komentar pengguna',
              description:
                  'Lihat komentar terbaru dan bersihkan komentar yang tidak sesuai dari ruang katalog PerfumeShelf.',
              icon: Icons.rate_review,
              metricLabel: 'Komentar',
              metricValue: '${SharedReviews.allReviews().length}',
              imageUrl: heroImageUrl,
            ),
            const SizedBox(height: 18),
            const Text(
              'Kelola Coment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Lihat komentar pengguna dan hapus komentar yang tidak sesuai.',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            if (SharedReviews.allReviews().isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Belum ada komentar user.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...SharedReviews.allReviews().map((entry) {
                final review = entry.review;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.reviewerName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.perfumeName,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RatingStars(rating: review.rating, size: 18),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(review.comment),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => deleteReview(entry),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Hapus Komentar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget buildUserManagementContent() {
    final users = reviewUserEntries();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            AppHeroSection(
              eyebrow: 'Kelola user',
              title: 'Pantau user dari komentar',
              description:
                  'Kelola user yang memberi komentar dan hapus user yang tidak sesuai dari ruang katalog PerfumeShelf.',
              icon: Icons.manage_accounts,
              metricLabel: 'User aktif',
              metricValue: '${users.length}',
              imageUrl: heroImageUrl,
            ),
            const SizedBox(height: 18),
            const Text(
              'Kelola User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Hapus user beserta komentar yang sudah dibuat.',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            if (users.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Belum ada user dari komentar.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...users.map((entry) {
                final review = entry.review;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.reviewerName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    review.reviewerEmail.trim().isEmpty
                                        ? 'Email tidak tersedia'
                                        : review.reviewerEmail,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Komentar terakhir: ${entry.perfumeName}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => deleteUserReviews(entry),
                            icon: const Icon(Icons.person_remove),
                            label: const Text('Hapus User'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedContent() {
    if (selectedIndex == 1) {
      return buildReviewContent();
    }

    if (selectedIndex == 2) {
      return buildUserManagementContent();
    }

    return buildHomeContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.name),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: openProfile),
        ],
      ),
      body: buildSelectedContent(),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: addPerfume,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 3) {
              addPerfume();
            } else if (index == 4) {
              openProfile();
            } else {
              setState(() => selectedIndex = index);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: 'Kelola Coment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Kelola User',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;

  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
