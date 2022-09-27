class PostEntity {
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
  final List<String> photos;

  PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.title,
    required this.executionDate,
    required this.budget,
    required this.ageFrom,
    required this.ageTo,
    required this.growthFrom,
    required this.growthTo,
    required this.city,
    required this.moreDescription,
    required this.performerGender,
    required this.isTatoo,
    required this.isForeignPassport,
    required this.otherDetails,
    required this.category,
    required this.createdDate,
    required this.lastUpdatedDate,
    required this.photos,
  });
}