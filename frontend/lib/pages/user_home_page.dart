import 'dart:async';

import 'package:flutter/material.dart';

import '../data/sample_perfumes.dart';
import '../data/shared_reviews.dart';
import '../models/app_user.dart';
import '../models/perfume.dart';
import '../models/perfume_review.dart';
import '../services/perfume_api.dart';
import '../theme/app_colors.dart';
import '../widgets/app_hero_section.dart';
import '../widgets/perfume_photo.dart';
import '../widgets/rating_stars.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'user_perfume_detail_page.dart';

class UserHomePage extends StatefulWidget {
  final AppUser? user;
  final bool isGuest;

  const UserHomePage({super.key, this.user, this.isGuest = false});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final perfumeApi = PerfumeApi();
  final searchController = TextEditingController();
  List<Perfume> perfumes = samplePerfumes();
  AppUser? currentUser;
  bool isLoading = true;
  int heroImageIndex = 0;
  Timer? heroImageTimer;

  Map<String, List<PerfumeReview>> get reviewsByPerfume =>
      SharedReviews.reviewsByPerfume;

  List<String> get heroImageUrls {
    final urls = perfumes
        .map((perfume) => perfume.imageUrl.trim())
        .where((imageUrl) => imageUrl.isNotEmpty)
        .toList();

    if (urls.isEmpty) {
      return [
        'https://images.unsplash.com/photo-1615634260167-c8cdede054de?auto=format&fit=crop&w=1200&q=82',
      ];
    }

    return urls;
  }

  String get heroImageUrl {
    final urls = heroImageUrls;
    return urls[heroImageIndex % urls.length];
  }

  String query = '';

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

  @override
  void dispose() {
    heroImageTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  List<Perfume> get filteredPerfumes {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return perfumes;

    return perfumes.where((perfume) {
      return perfume.namaParfum.toLowerCase().contains(keyword) ||
          perfume.merek.toLowerCase().contains(keyword) ||
          perfume.aroma.toLowerCase().contains(keyword);
    }).toList();
  }

  double averageRating(Perfume perfume) {
    final reviews = reviewsByPerfume[perfume.namaParfum] ?? [];
    if (reviews.isEmpty) return 0;

    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  Future<void> openPerfume(Perfume perfume) async {
    final result = await Navigator.push<PerfumeReview>(
      context,
      MaterialPageRoute(
        builder: (_) => UserPerfumeDetailPage(
          perfume: perfume,
          reviews: List.of(reviewsByPerfume[perfume.namaParfum] ?? []),
          isGuest: widget.isGuest,
          reviewerName: currentUser?.name ?? 'User PerfumeShelf',
          reviewerEmail: currentUser?.email ?? '',
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      SharedReviews.addReview(perfume.namaParfum, result);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review parfum berhasil dikirim')),
    );
  }

  Future<void> openProfile() async {
    if (widget.isGuest) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    final user = currentUser;
    if (user == null) return;

    final updatedUser = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
    );

    if (updatedUser == null || !mounted) return;

    setState(() => currentUser = updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final shownPerfumes = filteredPerfumes;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isGuest ? 'Guest Preview' : 'Katalog Parfum'),
        actions: [
          IconButton(
            icon: Icon(widget.isGuest ? Icons.login : Icons.person),
            onPressed: openProfile,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: LinearProgressIndicator(),
                      ),
                    AppHeroSection(
                      eyebrow: widget.isGuest
                          ? 'Guest preview'
                          : 'Katalog pilihan',
                      title: widget.isGuest
                          ? 'Jelajahi parfum sebelum login'
                          : 'Temukan aroma favoritmu',
                      description: widget.isGuest
                          ? 'Lihat koleksi parfum dan rating pengguna. Login untuk ikut menulis review.'
                          : 'Cari parfum berdasarkan merek, aroma, dan pengalaman pengguna lain di PerfumeShelf.',
                      icon: widget.isGuest ? Icons.visibility : Icons.spa,
                      metricLabel: widget.isGuest ? 'Bisa dilihat' : 'Parfum',
                      metricValue: '${perfumes.length}',
                      imageUrl: heroImageUrl,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: '${perfumes.length}',
                            subtitle: 'Parfum',
                            icon: Icons.spa,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title:
                                '${reviewsByPerfume.values.expand((item) => item).length}',
                            subtitle: 'Review',
                            icon: Icons.rate_review,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => setState(() => query = value),
                        decoration: InputDecoration(
                          hintText: 'Cari parfum, merek, atau aroma',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Bersihkan pencarian',
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() => query = '');
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Temukan Parfum',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Beri rating dan bagikan pengalaman kamu setelah mencoba parfum.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    if (widget.isGuest) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.30),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.visibility, color: AppColors.accent),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Mode Guest: kamu bisa melihat katalog. Login untuk memberi rating dan review.',
                                style: TextStyle(color: AppColors.textDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Login'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_add),
                              label: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (shownPerfumes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 56),
                        child: Center(
                          child: Text(
                            'Parfum tidak ditemukan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...shownPerfumes.map((perfume) {
                        final average = averageRating(perfume);
                        final reviews =
                            reviewsByPerfume[perfume.namaParfum] ?? [];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => openPerfume(perfume),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  PerfumePhoto(imageUrl: perfume.imageUrl),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          perfume.namaParfum,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${perfume.merek} - ${perfume.aroma}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            RatingStars(
                                              rating: average.round(),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              average == 0
                                                  ? 'Belum ada rating'
                                                  : '${average.toStringAsFixed(1)} (${reviews.length})',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            _AromaChip(label: perfume.aroma),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AromaChip extends StatelessWidget {
  final String label;

  const _AromaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
