
class CreateReviewEntity {
  final String text;
  final int mark;
  final int author;

  CreateReviewEntity({
    required this.text,
    required this.mark,
    required this.author,
  });

  Map<String, dynamic> toApi() {
    return {
      'text': text,
      'mark': mark,
      'author': author,
    };
  }
}
