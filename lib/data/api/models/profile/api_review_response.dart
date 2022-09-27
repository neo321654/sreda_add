
class ApiReviewResponse {
  final int? id;
  final int? mark;
  final String? text;
  final Map<String, dynamic>? author;


  ApiReviewResponse.fromApi(Map<String, dynamic> map)
      : id = map['id'],
        text = map['text'],
        author = map['author_object'],
        mark = map['mark'];
}
