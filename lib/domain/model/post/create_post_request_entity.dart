import 'dart:io';

class CreatePostRequestEntity {
  final String title;
  final String executionDate;
  final int budget;
  final String city;
  final String performerGender;
  final List<File> photos;
  final int ageFrom;
  final int ageTo;
  final int growthFrom;
  final int growthTo;
  final String isTattooOrPiercings;
  final bool isForeignPassport;
  final String otherDetails;
  final String category;

  CreatePostRequestEntity({
    required this.title,
    required this.executionDate,
    required this.budget,
    required this.city,
    required this.performerGender,
    required this.photos,
    required this.ageFrom,
    required this.ageTo,
    required this.growthFrom,
    required this.growthTo,
    required this.isTattooOrPiercings,
    required this.isForeignPassport,
    required this.otherDetails,
    required this.category,
  });

  Map<String, dynamic> toApi() {
    return {
      'title': title,
      'execution_date': executionDate,
      'budget': budget,
      'city': city,
      'performer_gender': performerGender,
      'photos': photos,
      'age_from': ageFrom,
      'age_to': ageTo,
      'growth_from': growthFrom,
      'growth_to': growthTo,
      //todo to String isTattooOrPiercings
      'is_tatoo_or_piercings': isTattooOrPiercings,
      'is_foreign_passport': isForeignPassport,
      'other_details': otherDetails,
      'category': category,
    };
  }
}
