import 'package:flutter/material.dart';

import '../data/sample_perfumes.dart';
import '../models/perfume.dart';
import '../models/perfume_review.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import '../widgets/rating_stars.dart';
import 'profile_page.dart';
import 'user_perfume_detail_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final searchController = TextEditingController();
  final perfumes = samplePerfumes();
  final Map<String, List<PerfumeReview>> reviewsByPerfume = {
    'Dior Sauvage': [
      PerfumeReview(
        reviewerName: 'Raka',
        rating: 5,
        comment: 'Fresh, maskulin, dan tahan lama untuk aktivitas sore.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
    'Bleu de Chanel': [
      PerfumeReview(
        reviewerName: 'Nadia',
        rating: 4,
        comment: 'Aromanya bersih dan elegan, cocok untuk kantor.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  String query = '';

  @override
  void dispose() {
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
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      reviewsByPerfume
          .putIfAbsent(perfume.namaParfum, () => [])
          .insert(0, result);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review parfum berhasil dikirim')),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shownPerfumes = filteredPerfumes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Parfum'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: openProfile),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Cari parfum, merek, atau aroma',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Temukan Parfum',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Beri rating dan bagikan pengalaman kamu setelah mencoba parfum.',
            style: TextStyle(color: Colors.grey),
          ),
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
              final reviews = reviewsByPerfume[perfume.namaParfum] ?? [];

              return Card(
                color: AppColors.card,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => openPerfume(perfume),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${perfume.merek} - ${perfume.aroma}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
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
                                    style: const TextStyle(color: Colors.grey),
                                  ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.secondary,
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
