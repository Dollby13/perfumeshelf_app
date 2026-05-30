import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../models/perfume_review.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import '../widgets/rating_stars.dart';

class UserPerfumeDetailPage extends StatefulWidget {
  final Perfume perfume;
  final List<PerfumeReview> reviews;

  const UserPerfumeDetailPage({
    super.key,
    required this.perfume,
    required this.reviews,
  });

  @override
  State<UserPerfumeDetailPage> createState() => _UserPerfumeDetailPageState();
}

class _UserPerfumeDetailPageState extends State<UserPerfumeDetailPage> {
  final nameController = TextEditingController(text: 'User PerfumeShelf');
  final reviewController = TextEditingController();
  int rating = 5;

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
        reviewerName: nameController.text.trim().isEmpty
            ? 'User PerfumeShelf'
            : nameController.text.trim(),
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
            child: Text(title, style: const TextStyle(color: Colors.grey)),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
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
                        borderRadius: 18,
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
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.perfume.merek} - ${widget.perfume.aroma}',
                              style: const TextStyle(color: Colors.grey),
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
                                      : averageRating.toStringAsFixed(1),
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
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beri Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 14),
                  RatingStars(
                    rating: rating,
                    size: 34,
                    onChanged: (value) => setState(() => rating = value),
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
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.reviews.isEmpty)
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Belum ada review. Jadilah yang pertama memberi review.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...widget.reviews.map((review) {
              return Card(
                color: Colors.white,
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
    );
  }
}
