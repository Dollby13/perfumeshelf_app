class PerfumeReview {
  final String reviewerName;
  final String reviewerEmail;
  final int rating;
  final String comment;
  final DateTime createdAt;

  PerfumeReview({
    required this.reviewerName,
    this.reviewerEmail = '',
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
