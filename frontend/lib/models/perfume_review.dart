class PerfumeReview {
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerPhoto;
  final int rating;
  final String comment;
  final DateTime createdAt;

  PerfumeReview({
    required this.reviewerName,
    this.reviewerEmail = '',
    this.reviewerPhoto = '',
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
