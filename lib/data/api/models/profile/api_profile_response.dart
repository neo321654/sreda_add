class ApiProfileResponse {
  final int? id;
  final List<dynamic>? profilePhotos;
  final String? name;
  final String userType;
  final int? gender;
  final int? age;
  final int? feedbackCount;
  final String? city;
  final String? phone;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? website;
  final String? about;
  final int? workerType;
  final int? closeSize;
  final int? shoesSize;
  final int? growth;
  final int? bust;
  final int? waist;
  final int? hips;
  final String? lookType;
  final String? skinColor;
  final String? hairColor;
  final String? hairLength;
  final bool isHaveInternationalPassport;
  final bool isHaveTattoo;
  final bool isHaveEnglish;
  final bool isFavorite;
  final String? photo;
  final String workType;
  final int userId;

  ApiProfileResponse.fromApi(Map<String, dynamic> map)
      : id = map['id'],
        profilePhotos = map['profile_photos'] ?? [],
        name = map['name'],
        userType = map['user_type'] ?? '',
        gender = map['gender'],
        age = map['age'],
        feedbackCount = map['feedback_count'],
        city = map['city'],
        phone = map['phone'],
        facebook = map['facebook'],
        instagram = map['instagram'],
        linkedin = map['linkedin'],
        website = map['website'],
        about = map['about'],
        workerType = map['worker_type'],
        closeSize = map['close_size'],
        shoesSize = map['shoes_size'],
        growth = map['growth'],
        bust = map['bust'],
        waist = map['waist'],
        hips = map['hips'],
        lookType = map['look_type'],
        skinColor = map['skin_color'],
        hairColor = map['hair_color'],
        hairLength = map['hair_length'],
        isHaveInternationalPassport = map['is_have_international_passport'] ?? false,
        isHaveTattoo = map['is_have_tattoo']?? false,
        isHaveEnglish = map['is_have_english'] ?? false,
        isFavorite = map['is_favorite'] ?? false,
        photo = map['photo'],
        workType = map['work_type'] ?? '',
        userId = map['user_id'];
}
