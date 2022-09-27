class ApiPostRequest {
  final String title;
  final String executionDate;
  final int budget;
  final String city;
  final String performerGender;
  final int ageFrom;
  final int ageTo;
  final int growthFrom;
  final int growthTo;
  final bool isTatooOrPiercings;
  final bool isForeignPassport;
  final String otherDetails;
  final String category;
  final int author;

  ApiPostRequest({
    required this.title,
    required this.executionDate,
    required this.budget,
    required this.city,
    required this.performerGender,
    required this.ageFrom,
    required this.ageTo,
    required this.growthFrom,
    required this.growthTo,
    required this.isTatooOrPiercings,
    required this.isForeignPassport,
    required this.otherDetails,
    required this.category,
    required this.author,
  });

  Map<String, dynamic> toApi() {
    return {
      'title': title,
      'password': executionDate,
      'budget': budget,
      'city': city,
      'performer_gender': performerGender,
      'age_from': ageFrom,
      'age_to': ageTo,
      'growth_from': growthFrom,
      'growth_to': growthTo,
      'is_tatoo_or_piercings': isTatooOrPiercings,
      'is_foreign_passport': isForeignPassport,
      'other_details': otherDetails,
      'category': category,
      'author': author,
    };
  }
}