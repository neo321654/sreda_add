import 'package:easy_localization/easy_localization.dart';

class ApiPostResponse {
  final int id;
  final int authorId;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String executionDate;
  final int budget;
  final int ageFrom;
  final int ageTo;
  final int growthFrom;
  final int growthTo;
  final String city;
  final String moreDescription;
  final String performerGender;
  final bool isTatoo;
  final bool isForeignPassport;
  final String otherDetails;
  final String category;
  final String createdDate;
  final String lastUpdatedDate;
  final List<dynamic> photos;

  ApiPostResponse.fromApi(Map<String, dynamic> map)
      : id = map['id'],
        authorId = map['author']['id'],
        authorName = map['author']['name'],
        authorAvatar = map['author']['photo']??'',
        title = map['title'],
        executionDate = map['execution_date'],
        budget = map['budget'],
        ageFrom = map['age_from'],
        ageTo = map['age_to'],
        growthFrom = map['growth_from'],
        growthTo = map['growth_to'],
        city = map['city'],
        moreDescription = map['more_description'] ?? '',
        performerGender = map['performer_gender'] ?? '',
        //isTatoo = map['is_tatoo_or_piercings'],
        isTatoo = true,
        isForeignPassport = map['is_foreign_passport'],
        otherDetails = map['other_details'],
        category = map['category'],
        createdDate = map['created_on'],
        lastUpdatedDate = map['last_modified'],
         photos = map['postphoto_set']
        //photos =  []
  {
    print('valera${map['is_tatoo_or_piercings']}');
  }
}