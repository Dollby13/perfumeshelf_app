import '../models/perfume_review.dart';

class ReviewEntry {
  final String perfumeName;
  final PerfumeReview review;

  const ReviewEntry({required this.perfumeName, required this.review});
}

class SharedReviews {
  static final Map<String, List<PerfumeReview>> reviewsByPerfume = {
    'Dior Sauvage': [
      PerfumeReview(
        reviewerName: 'Raka',
        reviewerPhoto:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
        rating: 5,
        comment: 'Fresh, maskulin, dan tahan lama untuk aktivitas sore.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
    'Bleu de Chanel': [
      PerfumeReview(
        reviewerName: 'Nadia',
        reviewerPhoto:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
        rating: 4,
        comment: 'Aromanya bersih dan elegan, cocok untuk kantor.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  static List<ReviewEntry> allReviews() {
    final entries = <ReviewEntry>[];

    reviewsByPerfume.forEach((perfumeName, reviews) {
      for (final review in reviews) {
        entries.add(ReviewEntry(perfumeName: perfumeName, review: review));
      }
    });

    entries.sort((a, b) => b.review.createdAt.compareTo(a.review.createdAt));
    return entries;
  }

  static void addReview(String perfumeName, PerfumeReview review) {
    reviewsByPerfume.putIfAbsent(perfumeName, () => []).insert(0, review);
  }

  static void removeReview(String perfumeName, PerfumeReview review) {
    reviewsByPerfume[perfumeName]?.remove(review);
  }

  static void removeReviewsByUser(String reviewerName) {
    for (final reviews in reviewsByPerfume.values) {
      reviews.removeWhere((review) => review.reviewerName == reviewerName);
    }
  }
}
