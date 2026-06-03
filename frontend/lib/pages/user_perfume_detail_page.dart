import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../models/perfume_review.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import '../widgets/rating_stars.dart';

class UserPerfumeDetailPage extends StatefulWidget {
  final Perfume perfume;
  final List<PerfumeReview> reviews;
  final bool isGuest;
  final String reviewerName;
  final String reviewerEmail;

  const UserPerfumeDetailPage({
    super.key,
    required this.perfume,
    required this.reviews,
    this.isGuest = false,
    this.reviewerName = 'User PerfumeShelf',
    this.reviewerEmail = '',
  });

  @override
  State<UserPerfumeDetailPage> createState() => _UserPerfumeDetailPageState();
}

class _UserPerfumeDetailPageState extends State<UserPerfumeDetailPage> {
  late final TextEditingController nameController;
  final reviewController = TextEditingController();
  int rating = 5;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.reviewerName);
  }

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  double get averageRating {
    if (widget.reviews.isEmpty) return 0;

    final total = widget.reviews.fold<int>(
      0,
      (sum, review) => sum + review.rating,
    );
    return total / widget.reviews.length;
  }

  void submitReview() {
    if (reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis review terlebih dahulu')),
      );
      return;
    }

    Navigator.pop(
      context,
      PerfumeReview(
        reviewerName: widget.reviewerName.trim().isEmpty
            ? 'User PerfumeShelf'
            : widget.reviewerName.trim(),
        reviewerEmail: widget.reviewerEmail,
        rating: rating,
        comment: reviewController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              title,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Parfum')),
      body: Stack(
        children: [
          _DetailBackground(imageUrl: widget.perfume.imageUrl),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PerfumePhoto(
                                imageUrl: widget.perfume.imageUrl,
                                width: 112,
                                height: 140,
                                borderRadius: 8,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.perfume.namaParfum,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.perfume.merek} - ${widget.perfume.aroma}',
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        RatingStars(
                                          rating: averageRating.round(),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          averageRating == 0
                                              ? 'Belum ada rating'
                                              : averageRating.toStringAsFixed(
                                                  1,
                                                ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          detailItem('Ukuran', widget.perfume.ukuran),
                          detailItem('Konsentrasi', widget.perfume.konsentrasi),
                          detailItem('Catatan', widget.perfume.catatan),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.isGuest)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.visibility, color: AppColors.accent),
                                SizedBox(width: 10),
                                Text(
                                  'Mode Guest',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Kamu bisa membaca detail dan review parfum. Untuk memberi rating atau menulis review, silakan login atau register terlebih dahulu.',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Beri Review',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: nameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Nama',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 14),
                            RatingStars(
                              rating: rating,
                              size: 34,
                              onChanged: (value) =>
                                  setState(() => rating = value),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: reviewController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Review kamu',
                                prefixIcon: Icon(Icons.rate_review),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: submitReview,
                                icon: const Icon(Icons.send),
                                label: const Text('Kirim Review'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Review Pengguna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.reviews.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'Belum ada review. Jadilah yang pertama memberi review.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    )
                  else
                    ...widget.reviews.map((review) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  RatingStars(rating: review.rating, size: 18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(review.comment),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBackground extends StatelessWidget {
  final String imageUrl;

  const _DetailBackground({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final backgroundImage = imageUrl.trim().isEmpty
        ? 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?auto=format&fit=crop&w=1600&q=80'
        : imageUrl;

    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            backgroundImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const ColoredBox(color: AppColors.background),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.82),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.3,
                colors: [
                  Colors.white.withValues(alpha: 0.26),
                  AppColors.background.withValues(alpha: 0.88),
                  AppColors.primaryDark.withValues(alpha: 0.10),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.38),
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
