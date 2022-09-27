
class ReviewEntity {
  final int? id;
  final String? text;
  final String? authorName;
  final String? authorPhoto;
  final String? profilePhotos;
  final int? mark;

  ReviewEntity({
    required this.id,
    required this.text,
    required this.mark,
    required this.authorName,
    required this.authorPhoto,
    required this.profilePhotos,
  });
}
